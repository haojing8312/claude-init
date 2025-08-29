#!/usr/bin/env bash

# Claude Code 中文开发套件设置脚本
# 该脚本将中文化的模板和配置文件复制到当前项目

set -euo pipefail

# 颜色定义
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# 获取目标目录（从环境变量或当前目录）
TARGET_DIR="${INSTALLER_ORIGINAL_PWD:-$(pwd)}"

print_color "$CYAN" "🎯 目标目录: $TARGET_DIR"
print_color "$CYAN" "📁 正在设置 Claude Code 中文开发环境..."
echo

# 检查是否在项目目录中
if [ ! -w "$TARGET_DIR" ]; then
    print_color "$RED" "❌ 无法写入目标目录: $TARGET_DIR"
    exit 1
fi

# 复制模板文件
print_color "$YELLOW" "📄 正在复制中文化模板文件..."

# 复制主要配置文件
if [ -f "templates/CLAUDE.md" ]; then
    cp "templates/CLAUDE.md" "$TARGET_DIR/" 2>/dev/null || {
        print_color "$YELLOW" "⚠️  CLAUDE.md 已存在，跳过复制"
    }
    print_color "$GREEN" "  ✅ CLAUDE.md (主 AI 上下文文件)"
fi

# 创建文档目录结构
mkdir -p "$TARGET_DIR/docs/ai-context"

# 复制文档文件
if [ -d "templates/docs" ]; then
    # 确保所有必要的子目录存在
    mkdir -p "$TARGET_DIR/docs/ai-context"
    
    # 复制所有文档文件
    find "templates/docs" -type f -name "*.md" | while read -r file; do
        # 获取相对路径
        rel_path="${file#templates/docs/}"
        target_file="$TARGET_DIR/docs/$rel_path"
        
        # 创建目标目录
        mkdir -p "$(dirname "$target_file")"
        
        # 复制文件（如果不存在）
        if [ ! -f "$target_file" ]; then
            cp "$file" "$target_file"
        fi
    done
    print_color "$GREEN" "  ✅ docs/ (中文文档系统)"
fi

# 创建 .claude 目录和 hooks
mkdir -p "$TARGET_DIR/.claude/hooks"

# 复制完整的 .claude 目录内容
if [ -d "templates/.claude" ]; then
    # 复制 commands 目录
    if [ -d "templates/.claude/commands" ]; then
        mkdir -p "$TARGET_DIR/.claude/commands"
        cp -r "templates/.claude/commands/"* "$TARGET_DIR/.claude/commands/" 2>/dev/null || true
        print_color "$GREEN" "  ✅ .claude/commands/ (Claude Code 命令集)"
    fi
    
    # 复制 hooks 目录
    if [ -d "templates/.claude/hooks" ]; then
        mkdir -p "$TARGET_DIR/.claude/hooks"
        cp -r "templates/.claude/hooks/"* "$TARGET_DIR/.claude/hooks/" 2>/dev/null || true
        # 确保脚本可执行
        chmod +x "$TARGET_DIR/.claude/hooks/"*.sh 2>/dev/null || true
        print_color "$GREEN" "  ✅ .claude/hooks/ (中文化 Hook 脚本和配置)"
    fi
    
    # 复制 settings.local.json（如果不存在）
    if [ -f "templates/.claude/settings.local.json" ] && [ ! -f "$TARGET_DIR/.claude/settings.local.json" ]; then
        cp "templates/.claude/settings.local.json" "$TARGET_DIR/.claude/" 2>/dev/null || true
        print_color "$GREEN" "  ✅ .claude/settings.local.json (本地配置)"
    fi
fi

# 创建示例目录
if [ -d "examples" ]; then
    mkdir -p "$TARGET_DIR/examples"
    cp -r "examples/"* "$TARGET_DIR/examples/" 2>/dev/null || true
    print_color "$GREEN" "  ✅ examples/ (中文使用示例)"
fi

echo
print_color "$CYAN" "🔧 正在初始化项目配置..."

# 创建基本的 .claude/settings.json（如果不存在）
SETTINGS_FILE="$TARGET_DIR/.claude/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "preToolUse": ["./.claude/hooks/subagent-context-injector.sh"],
    "userPromptSubmit": ["./.claude/hooks/gemini-context-injector.sh"]
  },
  "mcp": {},
  "tools": {}
}
EOF
    print_color "$GREEN" "  ✅ .claude/settings.json (Claude Code 配置)"
else
    print_color "$YELLOW" "  ⚠️  .claude/settings.json 已存在，跳过创建"
fi

echo
print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_color "$GREEN" "🎉 Claude Code 中文开发套件设置完成！"
print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

print_color "$CYAN" "📖 下一步："
echo "  1. 查看 CLAUDE.md 了解中文化的 AI 指令"
echo "  2. 阅读 docs/README.md 学习文档系统"
echo "  3. 参考 examples/ 目录中的使用示例"
echo "  4. 开始你的 Claude Code 中文开发之旅！"
echo
print_color "$YELLOW" "💡 提示：运行 'claude' 命令开始使用 Claude Code"