#!/bin/bash
# Gemini 上下文注入器
# 自动为 Gemini 咨询附加项目文档
#
# 此 hook 在创建新的 Gemini 咨询会话时自动附加
# 关键项目文档，确保 Gemini 始终具备完整的项目理解。
#
# 实现概述：
# - 在 .claude/settings.json 中注册为 userPromptSubmit hook
# - 检测 Gemini 咨询调用（mcp__gemini__consult_gemini）
# - 为新会话（无 session_id）附加项目结构和规则
# - 保留现有会话的用户附加文件
# - 通过 {"continue": true} 传递所有其他调用

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 从 stdin 读取输入
INPUT_JSON=$(cat)

# 提取工具使用信息
tool_uses=$(echo "$INPUT_JSON" | jq -r '.tool_uses // []' 2>/dev/null || echo '[]')

# 检查是否有 Gemini 咨询调用
has_gemini_consult=$(echo "$tool_uses" | jq -r 'map(select(.name == "mcp__gemini__consult_gemini")) | length > 0' 2>/dev/null || echo "false")

# 如果没有 Gemini 咨询调用，不变传递
if [[ "$has_gemini_consult" != "true" ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 查找 Gemini 咨询调用并检查是否为新会话
session_id=$(echo "$tool_uses" | jq -r 'map(select(.name == "mcp__gemini__consult_gemini")) | .[0].input.session_id // ""' 2>/dev/null || echo "")

# 如果有 session_id，这是现有会话，不要注入
if [[ -n "$session_id" && "$session_id" != "null" ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 为新会话，准备项目文档附件
PROJECT_STRUCTURE="$PROJECT_ROOT/docs/ai-context/project-structure.md"
MCP_RULES="$PROJECT_ROOT/MCP-ASSISTANT-RULES.md"

# 检查文档文件是否存在
docs_to_attach=()
if [[ -f "$PROJECT_STRUCTURE" ]]; then
    docs_to_attach+=("$PROJECT_STRUCTURE")
fi
if [[ -f "$MCP_RULES" ]]; then
    docs_to_attach+=("$MCP_RULES")
fi

# 如果没有找到文档文件，继续而不修改
if [[ ${#docs_to_attach[@]} -eq 0 ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 获取现有附加文件（如果有）
existing_files=$(echo "$tool_uses" | jq -r 'map(select(.name == "mcp__gemini__consult_gemini")) | .[0].input.attached_files // []' 2>/dev/null || echo '[]')

# 将项目文档添加到附加文件列表
all_files=$(echo "$existing_files" | jq --argjson project_docs "$(printf '%s\n' "${docs_to_attach[@]}" | jq -R . | jq -s .)" '. + $project_docs | unique')

# 更新工具调用以包含项目文档
updated_tool_uses=$(echo "$tool_uses" | jq "map(if .name == \"mcp__gemini__consult_gemini\" then .input.attached_files = $all_files else . end)")

# 创建更新的输入 JSON
output_json=$(echo "$INPUT_JSON" | jq --argjson updated_tools "$updated_tool_uses" '.tool_uses = $updated_tools')

# 输出修改后的 JSON
echo "$output_json"