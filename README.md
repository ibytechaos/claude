# Claude Code Orchestrator

一个强大的 Claude Code 插件系统,提供高级的集群编排、智能代理协调和自动化工作流管理能力。

## 特性

### 核心功能

- **🤖 智能集群编排** - 多代理协同工作系统,支持多种拓扑结构(分层、网格、环形、星形)
- **🧠 蜂群思维(Hive Mind)** - 集体智能系统,实现高级集群协调和共识决策
- **⚡ 并行执行优化** - 智能任务分配和并行处理,大幅提升执行效率
- **📊 性能分析** - 实时监控、性能报告、瓶颈检测和资源使用追踪
- **🔄 自动化工作流** - 预定义工作流和智能代理自动选择
- **💾 持久化内存** - 跨会话状态保持和智能记忆搜索
- **🎯 神经网络训练** - 内置模式学习和认知优化能力
- **🔗 GitHub 集成** - 代码审查、问题分类、PR 增强等 GitHub 操作

### 高级特性

- **自适应代理生成** - 根据任务自动选择和生成最优代理
- **拓扑优化** - 自动优化集群拓扑结构以提高性能
- **实时监控** - 全面的集群健康监控和指标收集
- **Hook 系统** - 支持任务前后、编辑前后等生命周期钩子
- **缓存管理** - 智能缓存协调和状态快照

## 安装

### 前置条件

- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) 已安装
- Git

### 安装步骤

1. 克隆本仓库:
```bash
git clone https://github.com/yourusername/claude.git
cd claude
```

2. 将插件链接到 Claude Code:
```bash
# 方式一:使用符号链接
ln -s $(pwd)/plugins/orchestrator ~/.claude/plugins/orchestrator

# 方式二:复制插件目录
cp -r plugins/orchestrator ~/.claude/plugins/
```

3. 验证安装:
```bash
orchestrator --help
```

## 快速开始

### 基础集群操作

```bash
# 初始化一个集群
orchestrator swarm init --topology hierarchical --max-agents 5

# 启动一个集群任务
orchestrator swarm "构建一个 REST API 服务" --strategy development

# 查看集群状态
orchestrator swarm status

# 实时监控集群
orchestrator swarm monitor
```

### 蜂群思维(Hive Mind)

```bash
# 初始化蜂群思维系统
orchestrator hive-mind init

# 生成蜂群集群
orchestrator hive-mind spawn "开发微服务架构"

# 查看蜂群状态
orchestrator hive-mind status

# 查看共识决策
orchestrator hive-mind consensus

# 查看蜂群记忆
orchestrator hive-mind memory
```

### 代理管理

```bash
# 生成特定类型的代理
orchestrator agents spawn --type researcher --name "研究员"
orchestrator agents spawn --type coder --name "编码者"

# 查看代理能力
orchestrator agents capabilities

# 查看代理类型
orchestrator agents types

# 代理协调
orchestrator agents coordinate --task "代码审查"
```

### 性能分析

```bash
# 生成性能报告
orchestrator analysis performance-report --format detailed

# 检测性能瓶颈
orchestrator analysis bottleneck-detect

# Token 使用分析
orchestrator analysis token-usage --timeframe 24h
```

### GitHub 集成

```bash
# 代码审查
orchestrator github code-review --pr 123

# 仓库分析
orchestrator github repo-analyze --analysis-type performance

# 问题分类
orchestrator github issue-triage --action categorize

# PR 增强
orchestrator github pr-enhance --pr 123
```

### 工作流管理

```bash
# 创建工作流
orchestrator workflows create --name "CI/CD Pipeline"

# 执行工作流
orchestrator workflows execute --workflow-id <id>

# 导出工作流
orchestrator workflows export --workflow-id <id> --format json
```

### 内存管理

```bash
# 存储记忆
orchestrator memory usage --action store --key "项目设置" --value "{...}"

# 检索记忆
orchestrator memory usage --action retrieve --key "项目设置"

# 搜索记忆
orchestrator memory search --pattern "API"

# 持久化记忆
orchestrator memory persist --session-id <id>
```

## 命令结构

插件采用模块化命令结构:

```
orchestrator
├── swarm              # 集群编排
│   ├── init          # 初始化集群
│   ├── spawn         # 生成集群任务
│   ├── status        # 集群状态
│   └── monitor       # 实时监控
├── hive-mind         # 蜂群思维
│   ├── init          # 初始化蜂群
│   ├── spawn         # 生成蜂群
│   ├── status        # 蜂群状态
│   ├── consensus     # 共识决策
│   └── memory        # 蜂群记忆
├── agents            # 代理管理
│   ├── spawn         # 生成代理
│   ├── types         # 代理类型
│   ├── capabilities  # 代理能力
│   └── coordinate    # 代理协调
├── analysis          # 性能分析
│   ├── performance-report
│   ├── bottleneck-detect
│   └── token-usage
├── automation        # 自动化
│   ├── auto-agent
│   ├── smart-spawn
│   └── workflow-select
├── github            # GitHub 集成
│   ├── code-review
│   ├── repo-analyze
│   ├── issue-triage
│   └── pr-enhance
├── workflows         # 工作流
│   ├── create
│   ├── execute
│   └── export
├── memory            # 内存管理
│   ├── usage
│   ├── search
│   └── persist
├── monitoring        # 监控
│   ├── agent-metrics
│   ├── swarm-monitor
│   └── real-time-view
├── optimization      # 优化
│   ├── topology-optimize
│   ├── parallel-execute
│   └── cache-manage
├── training          # 训练
│   ├── neural-train
│   ├── pattern-learn
│   └── model-update
├── coordination      # 协调
│   ├── swarm-init
│   ├── task-orchestrate
│   └── agent-spawn
└── hooks             # 钩子
    ├── pre-task
    ├── post-task
    ├── pre-edit
    └── post-edit
```

## 高级用法

### 自定义集群策略

```bash
# 研究策略
orchestrator swarm "分析机器学习算法" --strategy research --mode distributed

# 开发策略
orchestrator swarm "实现 GraphQL API" --strategy development --mode hierarchical

# 测试策略
orchestrator swarm "端到端测试套件" --strategy testing --mode mesh

# 分析策略
orchestrator swarm "性能基准测试" --strategy analysis --mode centralized
```

### 并行执行

```bash
# 启用并行执行
orchestrator optimization parallel-execute --tasks "[task1,task2,task3]"

# 拓扑优化
orchestrator optimization topology-optimize --swarm-id <id>

# 缓存管理
orchestrator optimization cache-manage --action warm --key "config"
```

### 神经网络训练

```bash
# 训练模式识别
orchestrator training pattern-learn --pattern-type coordination

# 神经网络训练
orchestrator training neural-train --epochs 100

# 模型更新
orchestrator training model-update --model-id <id>
```

## Hook 系统

插件包含完整的 Hook 系统,可在关键时刻自动执行操作:

### 可用的 Hooks

- **PreToolUse** - 工具使用前触发
  - Bash 命令修改
  - 文件编辑修改

- **PostToolUse** - 工具使用后触发
  - 命令结果跟踪
  - 文件编辑后格式化

- **PreCompact** - 上下文压缩前触发
  - 手动/自动压缩指导
  - 代理上下文提醒

- **Stop** - 会话结束时触发
  - 生成会话摘要
  - 持久化状态
  - 导出指标

### Hook 配置

Hook 配置位于 `plugins/orchestrator/hooks/hooks.json`。

## 配置

### 市场配置

在 `.claude-plugin/marketplace.json` 中配置插件信息:

```json
{
  "name": "claude",
  "description": "ibytechaos claude code plugins",
  "owner": {
    "name": "Claude Code Commands Community",
    "email": "ibytechaos.ai@gmail.com"
  },
  "version": "1.0.1",
  "plugins": [
    {
      "name": "orchestrator",
      "source": "./plugins/orchestrator/",
      "description": "orchestrator for claude flow",
      "category": "development"
    }
  ]
}
```

## 代理类型

系统支持多种专业代理类型:

- **Researcher** - 研究和信息收集
- **Coder** - 代码编写和实现
- **Analyst** - 数据分析和洞察
- **Optimizer** - 性能优化和改进
- **Coordinator** - 任务协调和管理
- **Tester** - 测试和质量保证
- **Reviewer** - 代码审查和反馈
- **Architect** - 架构设计和规划

## 集群拓扑

支持多种集群拓扑结构:

- **Hierarchical** - 分层结构,适合复杂任务分解
- **Mesh** - 网格结构,所有节点互联
- **Ring** - 环形结构,顺序处理
- **Star** - 星形结构,中心协调模式

## 执行策略

- **Research** - 专注于研究和信息收集
- **Development** - 专注于开发和实现
- **Analysis** - 专注于分析和洞察
- **Testing** - 专注于测试和验证

## 协调模式

- **Centralized** - 中心化协调
- **Distributed** - 分布式协调
- **Hierarchical** - 分层协调
- **Mesh** - 网格协调

## 最佳实践

1. **选择合适的拓扑** - 根据任务复杂度选择拓扑结构
2. **限制代理数量** - 避免过多代理导致协调开销
3. **使用并行执行** - 对独立任务启用并行处理
4. **监控性能** - 定期检查性能指标和瓶颈
5. **利用记忆系统** - 存储重要配置和状态
6. **定制工作流** - 为常见任务创建自定义工作流
7. **启用 Hooks** - 利用 Hook 系统自动化重复操作

## 故障排除

### 集群无法启动

```bash
# 检查集群状态
orchestrator swarm status

# 查看详细日志
orchestrator monitoring real-time-view
```

### 性能问题

```bash
# 检测瓶颈
orchestrator analysis bottleneck-detect

# 优化拓扑
orchestrator optimization topology-optimize
```

### 内存问题

```bash
# 清理缓存
orchestrator optimization cache-manage --action clear

# 检查内存使用
orchestrator memory usage --action list
```

## 贡献

欢迎贡献!请遵循以下步骤:

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 相关链接

- [Claude Code 官方文档](https://docs.claude.com/en/docs/claude-code)
- [插件开发指南](https://docs.claude.com/en/docs/claude-code/plugins)
- [问题反馈](https://github.com/yourusername/claude/issues)

## 致谢

感谢 Claude Code 团队提供强大的 AI 编程助手平台。

## 更新日志

### v1.0.1 (当前版本)

- 初始发布
- 完整的集群编排系统
- 蜂群思维功能
- GitHub 集成
- 性能分析工具
- 自动化工作流
- Hook 系统
- 持久化内存

## 支持

如有问题或需要帮助,请:

1. 查看 [文档](./plugins/orchestrator/commands/)
2. 提交 [Issue](https://github.com/yourusername/claude/issues)
3. 联系邮箱:ibytechaos.ai@gmail.com

---

Made with ❤️ by Claude Code Commands Community
