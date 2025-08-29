#!/bin/bash
# 通知 Hook
# 为重要的 Claude Code 事件发送系统通知
#
# 此 hook 监控特定工具调用和事件，
# 通过系统通知提醒用户重要活动。
#
# 支持的通知：
# - 长时间运行的任务完成
# - 错误和警告
# - 重要的文件修改
# - MCP 服务器连接状态

set -euo pipefail

# 检查通知系统可用性
HAS_NOTIFY=false
if command -v osascript >/dev/null 2>&1; then
    # macOS 通知支持
    HAS_NOTIFY=true
    NOTIFY_CMD="osascript"
elif command -v notify-send >/dev/null 2>&1; then
    # Linux 通知支持
    HAS_NOTIFY=true
    NOTIFY_CMD="notify-send"
fi

# 如果没有通知系统，静默退出
if [[ "$HAS_NOTIFY" != "true" ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 发送通知函数
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    
    if [[ "$NOTIFY_CMD" == "osascript" ]]; then
        # macOS 通知
        osascript -e "display notification \"$message\" with title \"Claude Code\" subtitle \"$title\""
    elif [[ "$NOTIFY_CMD" == "notify-send" ]]; then
        # Linux 通知
        notify-send -u "$urgency" "Claude Code - $title" "$message"
    fi
}

# 从 stdin 读取输入
INPUT_JSON=$(cat)

# 提取相关信息
tool_name=$(echo "$INPUT_JSON" | jq -r '.tool_name // ""')
tool_input=$(echo "$INPUT_JSON" | jq -r '.tool_input // {}')

# 根据工具类型发送适当通知
case "$tool_name" in
    "Task")
        # Task 工具调用 - 通知子智能体启动
        task_desc=$(echo "$tool_input" | jq -r '.description // "未知任务"')
        send_notification "任务启动" "启动子智能体：$task_desc"
        ;;
    
    "Bash")
        # 长时间运行的命令通知
        command=$(echo "$tool_input" | jq -r '.command // ""')
        timeout=$(echo "$tool_input" | jq -r '.timeout // 120000')
        run_in_bg=$(echo "$tool_input" | jq -r '.run_in_background // false')
        
        if [[ "$run_in_bg" == "true" ]] || [[ "$timeout" -gt 300000 ]]; then
            send_notification "后台任务" "启动长时间运行的命令"
        fi
        ;;
    
    mcp__*)
        # MCP 服务器调用通知
        server_name=$(echo "$tool_name" | cut -d'_' -f3)
        send_notification "MCP 调用" "调用 $server_name 服务器"
        ;;
    
    "Write"|"MultiEdit")
        # 文件修改通知
        file_path=$(echo "$tool_input" | jq -r '.file_path // ""')
        if [[ -n "$file_path" ]]; then
            filename=$(basename "$file_path")
            send_notification "文件修改" "正在编辑：$filename"
        fi
        ;;
esac

# 检查错误模式
error_message=$(echo "$INPUT_JSON" | jq -r '.error // ""')
if [[ -n "$error_message" && "$error_message" != "null" ]]; then
    send_notification "错误" "$error_message" "critical"
fi

# 继续正常执行
echo '{"continue": true}'