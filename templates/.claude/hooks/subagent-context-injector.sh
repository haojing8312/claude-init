#!/bin/bash
# 子智能体上下文自动加载器
# 自动为 Task 工具提示增强必要的项目上下文
#
# 此 hook 确保通过 Task 工具生成的每个子智能体自动
# 接收核心项目文档，消除了在每个 Task 提示中手动
# 包含上下文的需要。
#
# 实现概述：
# - 在 .claude/settings.json 中注册为 PreToolUse hook
# - 在执行前拦截所有 Task 工具调用
# - 注入对 CLAUDE.md、project-structure.md 和 docs-overview.md 的引用
# - 通过前置上下文而不是替换来保留原始提示
# - 通过 {"continue": true} 不变地传递非 Task 工具

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 从 stdin 读取输入
INPUT_JSON=$(cat)

# 提取工具信息
tool_name=$(echo "$INPUT_JSON" | jq -r '.tool_name // ""')

# 仅处理 Task 工具调用 - 所有其他工具不变传递
if [[ "$tool_name" != "Task" ]]; then
    echo '{"continue": true}'
    exit 0
fi

# 从 Task 工具输入中提取当前提示
current_prompt=$(echo "$INPUT_JSON" | jq -r '.tool_input.prompt // ""')

# 构建带项目文档引用的上下文注入头
# 这些文件通过 @ 引用自动可用于所有子智能体
context_injection="## 自动加载的项目上下文

此子智能体自动访问以下项目文档：
- @$PROJECT_ROOT/docs/CLAUDE.md (项目概览、编码标准和 AI 指令)
- @$PROJECT_ROOT/docs/ai-context/project-structure.md (完整文件树和技术栈)
- @$PROJECT_ROOT/docs/ai-context/docs-overview.md (文档架构)

这些文件提供了关于项目结构、
约定和开发模式的基本上下文。根据你的任务需要引用它们。

---

## 你的任务

"

# 将上下文注入与原始提示结合
# 上下文前置以保留原始任务指令
modified_prompt="${context_injection}${current_prompt}"

# 用修改后的提示更新输入 JSON
# 这维护所有其他工具输入字段不变
output_json=$(echo "$INPUT_JSON" | jq --arg new_prompt "$modified_prompt" '.tool_input.prompt = $new_prompt')

# 输出修改后的 JSON 供 Claude Code 处理
# Task 工具将接收增强的带上下文的提示
echo "$output_json"