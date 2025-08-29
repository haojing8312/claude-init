#!/usr/bin/env bash

# Claude Code 中文开发套件远程安装器
#
# 该脚本下载并安装 Claude Code 中文开发套件
# 使用方法: curl -fsSL https://raw.githubusercontent.com/cfrs2005/claude-init/main/install-cn.sh | bash

set -euo pipefail

# 配置
REPO_OWNER="cfrs2005"
REPO_NAME="claude-init"
BRANCH="main"

# 输出颜色
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 打印彩色输出
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# 进度指示器
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# 打印横幅
clear
print_color "$BLUE" "╔═══════════════════════════════════════════════╗"
print_color "$BLUE" "║                                               ║"
print_color "$BLUE" "║    🚀 Claude Code 中文开发套件安装器         ║"
print_color "$BLUE" "║                                               ║"
print_color "$BLUE" "╚═══════════════════════════════════════════════╝"
echo

# 检查必需命令
print_color "$YELLOW" "📋 正在检查系统要求..."
MISSING_DEPS=""

for cmd in curl tar mktemp; do
    if ! command -v "$cmd" &> /dev/null; then
        MISSING_DEPS="$MISSING_DEPS $cmd"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    print_color "$RED" "❌ 缺少必需命令:$MISSING_DEPS"
    print_color "$RED" "请在运行安装器前安装这些命令。"
    exit 1
fi

print_color "$GREEN" "✅ 系统要求已满足"
echo

# 创建临时目录并设置清理
TEMP_DIR=$(mktemp -d)
cleanup() {
    if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
        print_color "$YELLOW" "🧹 正在清理临时文件..."
        rm -rf "$TEMP_DIR"
        print_color "$GREEN" "✅ 清理完成"
    fi
}
trap cleanup EXIT INT TERM

# 下载框架
print_color "$CYAN" "📥 正在下载 Claude Code 中文开发套件..."
DOWNLOAD_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/tarball/${BRANCH}"

# 带进度指示的下载
(
    if ! curl -fsSL "$DOWNLOAD_URL" \
        -H "Accept: application/vnd.github.v3+json" \
        -o "$TEMP_DIR/framework.tar.gz" 2>"$TEMP_DIR/download.log"; then
        echo "DOWNLOAD_FAILED" > "$TEMP_DIR/status"
    else
        echo "DOWNLOAD_SUCCESS" > "$TEMP_DIR/status"
    fi
) &

DOWNLOAD_PID=$!
spinner $DOWNLOAD_PID
wait $DOWNLOAD_PID

# 检查下载状态
if [ -f "$TEMP_DIR/status" ] && [ "$(cat "$TEMP_DIR/status")" = "DOWNLOAD_FAILED" ]; then
    print_color "$RED" "❌ 下载框架失败"
    if [ -f "$TEMP_DIR/download.log" ] && [ -s "$TEMP_DIR/download.log" ]; then
        print_color "$RED" "错误详情："
        cat "$TEMP_DIR/download.log"
    fi
    echo
    print_color "$YELLOW" "可能的解决方案："
    echo "  1. 检查你的网络连接"
    echo "  2. 验证仓库是否存在: https://github.com/${REPO_OWNER}/${REPO_NAME}"
    echo "  3. 确保 Claude Code 已安装: https://github.com/anthropics/claude-code"
    echo "  4. 尝试手动安装 (git clone)"
    exit 1
fi

# 显示下载大小
if [ -f "$TEMP_DIR/framework.tar.gz" ]; then
    SIZE=$(ls -lh "$TEMP_DIR/framework.tar.gz" | awk '{print $5}')
    print_color "$GREEN" "✅ 下载完成 (${SIZE}B)"
else
    print_color "$RED" "❌ 未找到下载文件"
    exit 1
fi

# 解压文件
echo
print_color "$CYAN" "📦 正在解压框架文件..."

# 带进度指示的解压
(
    if ! tar -xzf "$TEMP_DIR/framework.tar.gz" -C "$TEMP_DIR" 2>"$TEMP_DIR/extract.log"; then
        echo "EXTRACT_FAILED" > "$TEMP_DIR/extract_status"
    else
        echo "EXTRACT_SUCCESS" > "$TEMP_DIR/extract_status"
    fi
) &

EXTRACT_PID=$!
spinner $EXTRACT_PID
wait $EXTRACT_PID

# 检查解压状态
if [ -f "$TEMP_DIR/extract_status" ] && [ "$(cat "$TEMP_DIR/extract_status")" = "EXTRACT_FAILED" ]; then
    print_color "$RED" "❌ 解压框架失败"
    if [ -f "$TEMP_DIR/extract.log" ] && [ -s "$TEMP_DIR/extract.log" ]; then
        print_color "$RED" "错误详情："
        cat "$TEMP_DIR/extract.log"
    fi
    exit 1
fi

# 查找解压目录 (GitHub 创建带提交哈希的目录)
EXTRACT_DIR=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d -name "${REPO_OWNER}-${REPO_NAME}-*" | head -n1)

if [ ! -d "$EXTRACT_DIR" ]; then
    print_color "$RED" "❌ 找不到解压的框架目录"
    print_color "$YELLOW" "查找位置: $TEMP_DIR"
    ls -la "$TEMP_DIR" 2>/dev/null || true
    exit 1
fi

print_color "$GREEN" "✅ 解压完成"
echo

# 验证 setup.sh 存在且可执行
if [ ! -f "$EXTRACT_DIR/setup.sh" ]; then
    print_color "$RED" "❌ 在解压文件中未找到 setup.sh"
    exit 1
fi

# 使 setup.sh 可执行
chmod +x "$EXTRACT_DIR/setup.sh"

# 保存更改前的原始目录
ORIGINAL_PWD="$(pwd)"

# 切换到解压目录并运行设置
cd "$EXTRACT_DIR"

print_color "$CYAN" "🔧 开始框架设置..."
print_color "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# 运行实际的设置脚本，通过环境变量传递原始目录
if ! INSTALLER_ORIGINAL_PWD="$ORIGINAL_PWD" ./setup.sh "$@"; then
    echo
    print_color "$RED" "❌ 设置失败"
    print_color "$YELLOW" "你可以尝试手动安装："
    echo "  git clone https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
    echo "  cd ${REPO_NAME}"
    echo "  ./setup.sh"
    exit 1
fi

# 成功！清理将通过 trap 自动进行
echo
print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_color "$GREEN" "🎉 Claude Code 中文开发套件安装完成！"
print_color "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"