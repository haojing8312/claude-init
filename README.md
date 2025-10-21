# Claude Code 中文开发套件

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: 中文](https://img.shields.io/badge/Language-%E4%B8%AD%E6%96%87-red.svg)](README.md)
[![Version](https://img.shields.io/github/v/release/cfrs2005/claude-init)](https://github.com/cfrs2005/claude-init/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/cfrs2005/claude-init/total)](https://github.com/cfrs2005/claude-init/releases)
[![Stars](https://img.shields.io/github/stars/cfrs2005/claude-init)](https://github.com/cfrs2005/claude-init/stargazers)
[![Forks](https://img.shields.io/github/forks/cfrs2005/claude-init)](https://github.com/cfrs2005/claude-init/network/members)
[![Issues](https://img.shields.io/github/issues/cfrs2005/claude-init)](https://github.com/cfrs2005/claude-init/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)](README.md)
[![Claude Code](https://img.shields.io/badge/Compatible-Claude%20Code-blue)](https://github.com/anthropics/claude-code)
[![MCP](https://img.shields.io/badge/Support-MCP%20Servers-green)](README.md#mcp-服务器支持)

<div align="center">

🚀 **为中国开发者定制的 Claude Code 智能开发环境**

[快速开始](#-快速开始) • [功能特性](#-特性) • [使用指南](#-使用指南) • [使用反馈](#-使用反馈) • [更新日志](CHANGELOG.md)

---


🚀 **新增智谱AI引擎**: 最新集成了 **[智谱大模型 (BigModel.cn)](https://www.bigmodel.cn/claude-code?ic=H0RNPV3LNZ)**。其旗舰 **GLM-4.5** 模型拥有媲美 Claude 的代码能力，并提供极具吸引力的包月服务，是入门和高频使用的绝佳选择。 **[点此注册即领2000万免费Tokens →](https://www.bigmodel.cn/claude-code?ic=H0RNPV3LNZ)**

</div>

基于 [Claude Code Development Kit](https://github.com/peterkrueck/Claude-Code-Development-Kit) 的完整中文本地化版本，提供零门槛的中文 AI 编程体验。

## ✨ 特性

### 🎯 完全中文化
- **中文 AI 指令** - 所有 AI 上下文和提示完全中文化
- **中文文档系统** - 三层文档架构的中文版本
- **中文错误信息** - 友好的中文错误提示和帮助
- **中文安装体验** - 从安装到配置全程中文

### 🧠 智能上下文管理
- **三层文档架构** - 基础层/组件层/功能层分级管理
- **自动上下文注入** - 子智能体自动获取项目上下文
- **智能文档路由** - 根据任务复杂度加载适当文档
- **跨会话状态管理** - 智能任务交接和状态保持

### 🔧 开发工具集成
- **Hook 系统** - 中文化的自动化 Hook 脚本
- **MCP 服务器支持** - Gemini 咨询、Context7 文档等
- **安全扫描** - 自动 MCP 调用安全检查
- **通知系统** - 重要事件的系统通知

### 📚 完整模板库
- **项目模板** - 多种编程语言的项目结构模板
- **文档模板** - 标准化的中文文档模板
- **配置示例** - 开箱即用的配置文件
- **Skills 扩展** - 模块化的能力扩展系统
- **示例项目** - Python、Node.js、Web 应用完整示例

## 🚀 快速开始

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/cfrs2005/claude-init/main/install.sh | bash
```

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/cfrs2005/claude-init.git
cd claude-init

# 运行安装脚本
./setup.sh
```

## 📖 使用指南

### 1. 开始使用

安装完成后，在任意项目中启动 Claude Code：

```bash
claude
```

现在你可以用中文与 AI 对话，所有上下文和提示都已本地化。

### 2. 🎯 MCP 服务器功能

#### 🧠 Gemini 深度咨询
**触发方式：** 对 Claude 说"咨询 Gemini" 或 "请 Gemini 分析"
**适用场景：**
- 复杂架构设计问题
- 代码性能优化建议  
- 多文件代码重构方案
- 深度技术问题分析

**发送内容：**
- 描述你的具体问题
- 附上相关代码文件
- 说明你想要什么类型的建议

**Gemini 能做什么：**
- 提供多种解决方案对比
- 深度代码审查和优化建议
- 架构设计最佳实践
- 跨技术栈的经验分享

#### 📚 Context7 文档查询  
**触发方式：** 询问任何开源库的最新用法
**适用场景：**
- 学习新框架或库
- 查找最新 API 文档
- 解决版本兼容问题

**发送内容：**
- 说出库名称（如 "React 的最新 hooks 用法"）
- 描述你想解决的具体问题

**Context7 能做什么：**
- 获取最新官方文档
- 提供实用代码示例
- 解释最新特性和变化

### 3. 💡 增强功能

#### 🎵 自定义通知音效
**默认路径：** `.claude/hooks/sounds/`
**支持格式：** `.mp3`, `.wav`, `.aiff`

**替换方式：**
```bash
# 替换任务完成音效
cp your-sound.mp3 .claude/hooks/sounds/complete.mp3

# 替换输入提示音效  
cp your-sound.mp3 .claude/hooks/sounds/input.mp3
```

#### 🔒 安全扫描
**自动功能：** 所有 MCP 调用前自动检查敏感信息
**检查内容：**
- API 密钥和令牌
- 密码和敏感配置
- 个人身份信息
- 私有代码片段

#### 🤖 智能上下文管理
**自动功能：** 子任务自动获取项目上下文
**工作方式：**
- 每个新任务自动加载项目文档
- 智能选择相关上下文信息
- 保持会话间状态一致性

### 4. 🎯 Claude Code 斜杠命令

安装后可使用的内置 Claude Code 命令：

```bash
# 📊 上下文分析
/full-context               # 全面上下文收集和分析

# 🔍 代码质量
/code-review               # 多专家角度代码审查

# 🧠 AI 咨询
/gemini-consult            # 与 Gemini 深入对话咨询

# 📝 文档管理
/create-docs               # 创建 AI 优化文档结构
/update-docs               # 保持文档与代码同步

# ♻️ 代码维护
/refactor                  # 智能重构代码

# 🤝 会话管理
/handoff                   # 保留上下文和任务状态

# 📡 MCP 工具
/mcp-status                # 检查 MCP 服务器状态
```

**使用方式：** 直接在 Claude Code 中输入斜杠命令
**自动功能：** 所有命令自动获得项目上下文注入

### 5. 🎯 Skills 模块化能力扩展

**什么是 Skills？** Skills 是 Claude Code 的强大功能，让你创建可复用的能力模块。

**核心特性：**
- 📦 **自动调用** - Claude 根据需求智能选择合适的 skill
- 🎯 **渐进加载** - 只在需要时加载，节省上下文空间
- 🔧 **易于创建** - 简单的 Markdown + YAML 格式
- 🌍 **灵活部署** - 全局或项目级别安装

**内置 Skills：**
- 📰 **News Skill** - Anthropic 新闻追踪和深度分析
  - 自动获取最新官方新闻
  - 多维度分析（技术、商业、行业）
  - 结构化知识整理

**使用示例：**
```
你：分析最新的 Anthropic 新闻
Claude：[自动使用 news skill 获取和分析]
```

**详细文档：** 查看 `templates/.claude/skills/README.md`

### 6. 📦 项目示例库

提供完整的项目模板，快速启动开发：

**可用示例：**

#### 🐍 Python 项目
- FastAPI Web 应用结构
- 数据科学项目配置
- 机器学习工作流

#### 🟢 Node.js 项目
- Express.js API 服务
- React 全栈应用
- 微服务架构

#### 🌐 Web 应用
- 前后端分离架构
- 移动端适配
- 部署和运维配置

**快速开始：**
```bash
# 复制示例项目
cp -r examples/python-project my-new-project
cd my-new-project

# 开始使用
claude
```

**详细文档：** 查看 `examples/README.md`

## 💬 使用反馈

### 🐛 问题反馈
**遇到问题？** [提交 Issue](https://github.com/cfrs2005/claude-init/issues)

**常见问题类型：**
- 安装失败或错误
- MCP 服务器无法使用  
- Hook 脚本不工作
- 中文显示异常
- 功能建议和改进

### 💡 功能建议
**想要新功能？** [发起讨论](https://github.com/cfrs2005/claude-init/discussions)

**建议包含：**
- 功能描述和使用场景
- 期望的工作方式
- 类似工具的参考

### 🤝 参与贡献
欢迎提交代码、文档改进和翻译优化！

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。

## 🙏 致谢

- [Claude Code Development Kit](https://github.com/peterkrueck/Claude-Code-Development-Kit) - 原始项目
- [Anthropic](https://www.anthropic.com/) - Claude Code 平台
- 所有贡献者和中文开发社区

---

🎉 **开始你的中文 AI 编程之旅吧！**

```bash
curl -fsSL https://raw.githubusercontent.com/cfrs2005/claude-init/main/install.sh | bash
```