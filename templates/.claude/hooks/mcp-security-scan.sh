#!/bin/bash
# MCP 安全扫描器
# 扫描 MCP 服务器调用中的潜在安全风险
#
# 此 hook 在执行前分析所有 MCP 工具调用，
# 检查可疑模式和潜在安全风险。
#
# 安全检查：
# - 检测文件系统访问模式
# - 监控网络调用
# - 验证输入清理
# - 标记可疑活动

set -euo pipefail

# 从 stdin 读取输入
INPUT_JSON=$(cat)

# 提取工具信息
tool_name=$(echo "$INPUT_JSON" | jq -r '.tool_name // ""')

# 仅处理 MCP 工具调用（以 "mcp__" 开头）
if [[ ! "$tool_name" =~ ^mcp__ ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 提取工具输入
tool_input=$(echo "$INPUT_JSON" | jq -r '.tool_input // {}')

# 安全检查函数
check_file_access() {
    # 检查文件路径访问模式
    local paths=$(echo "$tool_input" | jq -r '.. | strings | select(test("^(/|\\\\|[A-Za-z]:)"))' 2>/dev/null || echo "")
    
    if [[ -n "$paths" ]]; then
        # 检查敏感路径访问
        while IFS= read -r path; do
            case "$path" in
                /etc/passwd|/etc/shadow|/etc/hosts|/root/*|/home/*/.ssh/*|~/.ssh/*)
                    echo "警告：检测到访问敏感系统文件：$path"
                    return 1
                    ;;
            esac
        done <<< "$paths"
    fi
    return 0
}

check_network_calls() {
    # 检查网络相关参数
    local urls=$(echo "$tool_input" | jq -r '.. | strings | select(test("^https?://"))' 2>/dev/null || echo "")
    local ips=$(echo "$tool_input" | jq -r '.. | strings | select(test("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"))' 2>/dev/null || echo "")
    
    if [[ -n "$urls" || -n "$ips" ]]; then
        echo "信息：检测到网络调用 - 工具：$tool_name"
    fi
    return 0
}

check_command_injection() {
    # 检查潜在的命令注入模式
    local suspicious=$(echo "$tool_input" | jq -r '.. | strings | select(test(";|\\||&|\\$\\(|`"))' 2>/dev/null || echo "")
    
    if [[ -n "$suspicious" ]]; then
        echo "警告：检测到可疑命令字符在工具输入中"
        return 1
    fi
    return 0
}

# 执行安全检查
security_issues=0

if ! check_file_access; then
    ((security_issues++))
fi

if ! check_network_calls; then
    ((security_issues++))
fi

if ! check_command_injection; then
    ((security_issues++))
fi

# 如果发现安全问题，阻止执行
if [[ $security_issues -gt 0 ]]; then
    echo "{\"error\": \"安全扫描检测到 $security_issues 个潜在问题。出于安全考虑阻止执行。\"}"
    exit 1
fi

# 安全检查通过，继续执行
echo '{"continue": true}'