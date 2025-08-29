# Claude Code 中文开发套件

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: 中文](https://img.shields.io/badge/Language-%E4%B8%AD%E6%96%87-red.svg)](README.md)

🚀 **为中国开发者定制的 Claude Code 智能开发环境**

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

## 🚀 快速开始

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/cfrs2005/claude-init/main/install-cn.sh | bash
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

### 1. 初始化项目

安装完成后，你的项目将自动包含：

```
your-project/
├── CLAUDE.md                    # 中文 AI 上下文文件
├── docs/                        # 中文文档系统
│   ├── README.md               # 文档系统指南
│   └── ai-context/             # AI 上下文管理
│       ├── project-structure.md
│       └── docs-overview.md
├── .claude/                     # Claude Code 配置
│   ├── settings.json           # 主配置文件
│   └── hooks/                  # 自动化 Hook 脚本
└── examples/                   # 使用示例
```

### 2. 核心概念

#### 📋 三层文档架构

**第1层：基础层（很少变更）**
- `CLAUDE.md` - 项目级 AI 指令和编码标准
- 全局约定和架构原则

**第2层：组件层（偶尔变更）**  
- `CONTEXT.md` - 组件级架构模式
- 模块边界和集成规范

**第3层：功能层（频繁变更）**
- 功能级实现细节
- 与代码共同维护的文档

#### 🤖 智能体协作

```bash
# 启动 Claude Code
claude

# 系统自动为每个子任务注入适当上下文
# 无需手动指定项目文档
```

### 3. 高级功能

#### 🔍 Gemini 深度咨询

```python
# 复杂问题深度分析（自动附加项目文档）
mcp__gemini__consult_gemini(
    specific_question="如何优化这个API的性能？",
    problem_description="当前API响应时间过长...",
    attached_files=["src/api/routes.py"]
)
```

#### 📚 Context7 文档查询

```python
# 获取最新库文档
mcp__context7__get_library_docs(
    context7CompatibleLibraryID="/facebook/react",
    topic="hooks",
    tokens=8000
)
```

## 🛠 配置说明

### Claude Code 设置

编辑 `.claude/settings.json`:

```json
{
  "hooks": {
    "preToolUse": ["./.claude/hooks/subagent-context-injector.sh"],
    "userPromptSubmit": ["./.claude/hooks/gemini-context-injector.sh"]
  },
  "mcp": {},
  "tools": {}
}
```

### Hook 脚本说明

- **subagent-context-injector.sh** - 自动为子智能体注入项目上下文
- **gemini-context-injector.sh** - 为 Gemini 咨询自动附加项目文档  
- **mcp-security-scan.sh** - MCP 调用安全扫描
- **notify.sh** - 系统事件通知

## 📋 项目模板

### Python 项目
```
python-project/
├── CLAUDE.md
├── src/
│   ├── CONTEXT.md
│   ├── core/
│   ├── api/
│   └── utils/
├── tests/
├── docs/
└── .claude/
```

### Node.js 项目
```
nodejs-project/
├── CLAUDE.md  
├── src/
│   ├── CONTEXT.md
│   ├── components/
│   ├── services/
│   └── utils/
├── tests/
├── docs/
└── .claude/
```

## 🤝 贡献指南

欢迎贡献代码、文档和想法！

1. Fork 此仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m '添加某个很棒的功能'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 开发原则

- **简单直接** - 遵循 KISS 原则
- **用户优先** - 一切为了更好的中文开发体验
- **向后兼容** - 与原版 Claude Code Development Kit 保持兼容
- **文档驱动** - 良好的文档是项目成功的关键

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。

## 🙏 致谢

- [Claude Code Development Kit](https://github.com/peterkrueck/Claude-Code-Development-Kit) - 原始项目
- [Anthropic](https://www.anthropic.com/) - Claude Code 平台
- 所有贡献者和中文开发社区

## 📞 联系方式

- **GitHub Issues**: [提交问题和建议](https://github.com/cfrs2005/claude-init/issues)  
- **讨论区**: [GitHub Discussions](https://github.com/cfrs2005/claude-init/discussions)

---

🎉 **开始你的中文 AI 编程之旅吧！**

```bash
curl -fsSL https://raw.githubusercontent.com/cfrs2005/claude-init/main/install-cn.sh | bash
```