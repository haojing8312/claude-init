# 快速开始 - 使用 Spec-kit 开发

本文档将指导你如何使用 **spec-workflow-mcp** 开始 Claude Code China v2.0 的开发。

---

## 📋 前置准备

### 1. 确认环境

**你需要：**
- ✅ Claude Code 已安装
- ✅ spec-workflow-mcp 已安装（MCP 服务器）
- ✅ 本项目已克隆到本地

**验证 MCP 服务器：**
```bash
# 在 Claude Code 中运行
claude mcp list

# 应该看到 spec-workflow-mcp
```

如果没有安装，请运行：
```bash
claude mcp add spec-workflow -s user -- npx -y @spec-workflow/mcp
```

---

## 🚀 第一步：初始化 Specs 目录

### 1.1 在项目根目录启动 Claude Code

```bash
cd E:\code\work\claude-init-fork
claude
```

### 1.2 使用 spec-workflow-mcp 初始化

**在 Claude Code 中运行：**

```
你：使用 spec-workflow-mcp 初始化这个项目的 specs 目录
```

Claude Code 会自动调用 MCP 工具，执行：
```bash
mcp__spec-workflow-mcp__specs-workflow {
  "path": "E:\\code\\work\\claude-init-fork",
  "action": {
    "type": "init",
    "featureName": "Claude Code China v2.0 一键安装方案",
    "introduction": "为中国用户打造零门槛的 Claude Code + 国产大模型 + GUI 一键安装包"
  }
}
```

**预期输出：**
```
✅ 已创建 specs/ 目录结构
✅ 已生成初始规格文档模板
✅ 工作流已初始化
```

---

## 📝 第二步：创建第一个 Feature Spec

### 2.1 根据实现计划创建 Spec

**参考 IMPLEMENTATION_PLAN.md Phase 1.2.1，我们需要创建 5 个核心功能 Spec：**

1. `specs/feature-001-windows-installer.md` - Windows 安装程序
2. `specs/feature-002-nodejs-auto-install.md` - Node.js 自动安装
3. `specs/feature-003-claude-code-install.md` - Claude Code 安装
4. `specs/feature-004-opcode-integration.md` - Opcode GUI 集成
5. `specs/feature-005-glm46-config.md` - GLM-4.6 配置

### 2.2 创建第一个 Spec

**方法 1：手动创建**

创建 `specs/feature-001-windows-installer.md`：

```markdown
# Feature 001: Windows NSIS 安装程序

## 需求背景

目标用户（教师、文案工作者）完全不懂命令行，需要提供类似 QQ、微信的图形化安装程序。

## 功能描述

使用 NSIS 开发 Windows 原生安装程序，提供：
- 欢迎页面（项目介绍）
- 许可协议页面
- 组件选择页面
- 自定义配置页面（API Key 输入）
- 安装进度页面
- 完成页面

## 用户故事

**作为** 一名没有技术背景的老师
**我希望** 双击一个 .exe 文件就能完成所有安装
**以便** 我可以快速开始使用 AI 辅助写作

## 技术方案

### 技术选型
- **NSIS 3.x** - 成熟的 Windows 安装程序生成器
- **nsDialogs** - NSIS 的 GUI 插件
- **PowerShell** - 后端安装逻辑

### 架构设计

```
main.nsi (主脚本)
├── pages/
│   ├── welcome.nsi       # 欢迎页面
│   ├── license.nsi       # 许可协议
│   ├── components.nsi    # 组件选择
│   ├── glm_config.nsi    # API Key 配置
│   └── progress.nsi      # 安装进度
├── sections/
│   ├── nodejs.nsi        # Node.js 安装
│   ├── claude.nsi        # Claude Code 安装
│   └── opcode.nsi        # Opcode 安装
└── resources/
    ├── icon.ico
    ├── banner.bmp
    └── welcome.bmp
```

### 关键实现

**1. 调用 PowerShell 脚本：**
```nsis
Section "Install Node.js"
  DetailPrint "正在安装 Node.js..."
  ExecWait 'powershell -ExecutionPolicy Bypass -File "$INSTDIR\scripts\install_nodejs.ps1"' $0

  ${If} $0 != 0
    MessageBox MB_OK "Node.js 安装失败，请检查日志"
    Abort
  ${EndIf}
SectionEnd
```

**2. 自定义配置页面：**
```nsis
Var GLM_API_KEY

Function GLMConfigPage
  nsDialogs::Create 1018
  Pop $0

  ${NSD_CreateLabel} 0 0 100% 20u "请输入智谱 AI 的 API Key："
  ${NSD_CreateText} 0 25u 100% 15u ""
  Pop $GLM_API_KEY

  nsDialogs::Show
FunctionEnd
```

## 任务分解

### Phase 1: 基础结构 (Week 6)
- [ ] **Task 3.1.1**: 创建基础 NSIS 脚本
  - 输出：`installer/main.nsi`
  - 验收：可以编译出 .exe
  - 工时：8 小时

- [ ] **Task 3.1.2**: 准备资源文件
  - 设计安装程序图标
  - 创建欢迎页面图片
  - 编写许可协议
  - 输出：`installer/resources/`
  - 工时：4 小时

### Phase 2: 自定义页面 (Week 6)
- [ ] **Task 3.2.1**: GLM API Key 输入页面
  - 输出：`installer/pages/glm_config.nsi`
  - 验收：可以输入和保存 API Key
  - 工时：12 小时

- [ ] **Task 3.2.2**: 依赖检查页面
  - 检测 Windows 版本
  - 检测 Node.js
  - 显示检测结果
  - 输出：`installer/pages/dependency_check.nsi`
  - 工时：8 小时

### Phase 3: 集成 PowerShell (Week 7)
- [ ] **Task 3.3.1**: 在 NSIS 中调用 PowerShell
  - 集成 install_nodejs.ps1
  - 集成 install_claude.ps1
  - 集成 install_opcode.ps1
  - 工时：8 小时

- [ ] **Task 3.3.2**: 进度显示
  - 实时显示安装进度
  - 解析 PowerShell 输出
  - 工时：12 小时

### Phase 4: 打包与优化 (Week 7)
- [ ] **Task 3.4.1**: 编译和测试
  - 输出：ClaudeCodeChina-Setup.exe
  - 验收：可以成功安装
  - 工时：4 小时

- [ ] **Task 3.4.2**: 签名与压缩
  - 代码签名（如有证书）
  - 压缩优化
  - 工时：8 小时

## 验收标准

### 功能验收
- [ ] 可以生成 .exe 安装程序
- [ ] 双击启动，显示欢迎页面
- [ ] 可以选择安装组件
- [ ] 可以输入 API Key
- [ ] 显示安装进度
- [ ] 完成后显示成功页面
- [ ] 创建桌面快捷方式

### 性能验收
- [ ] 安装包大小 < 500MB
- [ ] 安装时间 < 5 分钟
- [ ] 启动时间 < 3 秒

### 兼容性验收
- [ ] Windows 10 (21H2, 22H2) 测试通过
- [ ] Windows 11 (22H2, 23H2) 测试通过

### 用户体验验收
- [ ] 非技术用户可独立完成安装
- [ ] 安装成功率 > 95%
- [ ] 用户满意度 > 4.5/5

## 测试计划

### 单元测试
- NSIS 脚本编译测试
- 各个页面显示测试

### 集成测试
- 完整安装流程测试
- PowerShell 脚本调用测试
- 错误处理测试

### 系统测试
| 测试场景 | 预期结果 |
|---------|---------|
| 干净的 Windows 10 | 全部安装成功 |
| 已安装 Node.js | 检测到，询问是否重装 |
| 磁盘空间不足 | 显示错误，中止安装 |
| 网络断开 | 显示错误，支持重试 |

### 用户验收测试
- 招募 10-15 名非技术用户
- 记录安装过程和反馈
- 收集改进建议

## 风险与依赖

### 技术风险
- **NSIS 学习曲线**: 提前技术调研
- **PowerShell 执行策略限制**: 自动修改策略

### 依赖项
- **前置依赖**:
  - PowerShell 脚本已开发完成
  - 测试环境已准备

- **外部依赖**:
  - NSIS 3.x
  - UPX (压缩工具)

## 参考资料

- [NSIS 官方文档](https://nsis.sourceforge.io/Docs/)
- [nsDialogs 教程](https://nsis.sourceforge.io/Docs/nsDialogs/Readme.html)
- [成熟项目参考](https://github.com/obsproject/obs-studio/tree/master/cmake/windows)

---

**创建日期**: 2025-10-27
**负责人**: 开发团队
**优先级**: P0 (Critical)
**预计工时**: 52 小时
**目标完成**: Week 7
```

### 2.3 使用 spec-workflow-mcp 确认规格

**在 Claude Code 中运行：**

```
你：检查当前项目的 specs 工作流状态
```

Claude Code 会调用：
```bash
mcp__spec-workflow-mcp__specs-workflow {
  "path": "E:\\code\\work\\claude-init-fork",
  "action": { "type": "check" }
}
```

---

## 🔨 第三步：开始开发

### 3.1 按照 Spec 开发功能

**示例：开发 Task 3.1.1**

```
你：我要开始开发 Task 3.1.1：创建基础 NSIS 脚本。
请帮我创建 installer/main.nsi 文件。
```

Claude Code 会：
1. 读取 Spec 文档
2. 理解需求
3. 生成代码
4. 创建文件

### 3.2 标记任务完成

**当你完成一个任务后：**

```
你：我已经完成了 Task 3.1.1，请标记为已完成
```

Claude Code 会调用：
```bash
mcp__spec-workflow-mcp__specs-workflow {
  "path": "E:\\code\\work\\claude-init-fork",
  "action": {
    "type": "complete_task",
    "taskNumber": "3.1.1"
  }
}
```

**预期输出：**
```
✅ Task 3.1.1 已标记为完成
📊 当前进度: 1/16 任务已完成 (6.25%)
```

---

## 📊 第四步：跟踪进度

### 4.1 查看整体进度

```
你：显示当前项目的开发进度
```

输出示例：
```
📋 Claude Code China v2.0 开发进度

Feature 001: Windows NSIS 安装程序
  ✅ Task 3.1.1: 创建基础 NSIS 脚本
  ⏳ Task 3.1.2: 准备资源文件
  ⏳ Task 3.2.1: GLM API Key 输入页面
  ⏳ Task 3.2.2: 依赖检查页面

  进度: 1/16 (6.25%)

Feature 002: Node.js 自动安装
  ⏳ 未开始

总体进度: 1/50+ (2%)
```

### 4.2 切换到下一个任务

```
你：我要开始 Task 3.1.2，请帮我准备资源文件
```

---

## 🎯 推荐工作流

### Daily Workflow (每日工作流程)

```
1. 启动 Claude Code
   cd E:\code\work\claude-init-fork
   claude

2. 查看今天的任务
   你：显示待办任务

3. 选择一个任务开始
   你：我要开始 Task X.X.X

4. 开发功能
   你：[具体的开发需求]

5. 完成后标记
   你：Task X.X.X 已完成

6. 提交代码
   git add .
   git commit -m "feat: 完成 Task X.X.X"
   git push

7. 重复步骤 2-6
```

### Weekly Review (每周回顾)

```
每周五：
1. 查看本周进度
   你：显示本周完成的任务

2. 更新 IMPLEMENTATION_PLAN.md
   标记已完成的里程碑

3. 规划下周任务
   根据 Spec 安排下周的任务优先级
```

---

## 📚 常见命令速查

### Spec-workflow MCP 命令

```bash
# 初始化项目
specs-workflow init

# 检查状态
specs-workflow check

# 完成任务
specs-workflow complete-task --taskNumber "3.1.1"

# 跳过任务
specs-workflow skip --taskNumber "3.1.2"

# 确认规格
specs-workflow confirm
```

### Git 工作流

```bash
# 查看状态
git status

# 创建功能分支
git checkout -b feature/windows-installer

# 提交代码
git add .
git commit -m "feat(installer): 添加 NSIS 基础脚本"

# 推送到远程
git push origin feature/windows-installer

# 合并到主分支
git checkout main
git merge feature/windows-installer
```

---

## 🆘 遇到问题？

### 常见问题

**Q1: spec-workflow-mcp 命令不可用**
```bash
# 检查 MCP 服务器状态
claude mcp list

# 重新安装
claude mcp add spec-workflow -s user -- npx -y @spec-workflow/mcp
```

**Q2: 找不到 specs 目录**
```bash
# 手动创建
mkdir specs

# 然后初始化
你：使用 spec-workflow-mcp 初始化 specs 目录
```

**Q3: 任务完成后状态没有更新**
```bash
# 检查 specs 目录结构
ls -la specs/

# 确认 Spec 文档格式正确
# 任务列表应该使用 Markdown 格式：
# - [ ] Task 3.1.1: 任务描述
```

---

## 🎉 下一步

恭喜！你已经准备好开始开发了。

**建议的开发顺序：**

1. **Week 1-2**: Phase 1 基础设施搭建
   - 创建所有 Spec 文档
   - 开发原型验证技术可行性

2. **Week 3-5**: Phase 2 Windows 脚本开发
   - 按照 Spec 逐个实现功能
   - 每完成一个任务就标记

3. **Week 6-7**: Phase 3 NSIS 安装程序
   - 集成所有脚本
   - 打包为 .exe

4. **Week 8**: Phase 4 测试与优化
   - 全面测试
   - 修复 Bug

5. **Week 9**: Phase 5 文档与发布
   - 编写文档
   - 正式发布 v2.0.0

---

**准备好了吗？开始你的第一个任务吧！** 🚀

```
你：使用 spec-workflow-mcp 初始化这个项目的 specs 目录
```
