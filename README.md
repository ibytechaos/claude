# ibytechaos/claude — Claude Code 配置分发中心

精品 skills/plugins/MCP 集中管理。从顶级开源项目精选组装 + 自有插件。

## 快速开始

```bash
git clone --recurse-submodules https://github.com/ibytechaos/claude.git
cd claude
make assemble    # 从 external/ 精选组装到 dist/
make install     # 安装到 ~/.claude/skills/
```

## 包含内容

### 自有插件
- **chrome-cdp** — Chrome DevTools Protocol 调试

### 精选 Skills（from everything-claude-code 116k⭐）
- tdd-workflow, security-review, code-review, verification-loop
- agentic-engineering, continuous-learning, deep-research
- rust-patterns, rust-testing, python-patterns, python-testing
- api-design, architecture-decision-records, git-workflow
- codebase-onboarding, repo-scan, search-first

### 精选 Skills（from frontend-slides 11.6k⭐）
- frontend-slides — HTML 演示文稿生成

### 精选 Agents（from everything-claude-code）
- code-reviewer, security-reviewer, architect, planner
- tdd-guide, performance-optimizer, rust-reviewer

### MCP 配置模板
- 全局：notebooklm-mcp
- 项目级：drawio（obsidian）

## 命令

| 命令 | 作用 |
|------|------|
| `make assemble` | 从 external/ 精选组装到 dist/ |
| `make install` | 安装 dist/ 到 ~/.claude/skills/ |
| `make sync-project PROJECT=path` | 同步 MCP 到指定项目 |
| `make list` | 列出已组装/已安装内容 |
| `make update` | 更新 submodules |
| `make clean` | 清理 dist/ |

## 外部项目（submodule）

| 项目 | Stars | 用途 |
|------|-------|------|
| [everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 116k | 130+ skills, 30 agents, 60 commands |
| [frontend-slides](https://github.com/zarazhangrui/frontend-slides) | 11.6k | HTML 演示文稿 |
