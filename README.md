# Claude Code Skills Collection

个人收集和封装的 Claude Code 技能插件集合。

## 安装

```bash
# 1. 添加为 marketplace 源
claude plugin marketplace add https://github.com/ibytechaos/claude

# 2. 安装插件
claude plugin install chrome-cdp
```

也可以指定安装范围（默认 user，可选 project / local）：

```bash
claude plugin install chrome-cdp --scope project
```

或者临时加载（不持久安装，仅当次会话）：

```bash
claude --plugin-dir /path/to/claude/skills/chrome-cdp
```

## 包含的 Skills

### chrome-cdp

轻量级 Chrome DevTools Protocol CLI，让 Claude Code 能直接操控你本地正在运行的 Chrome 浏览器。

**核心能力：**
- 连接你已打开的 Chrome 标签页（Gmail、GitHub、内部工具等，无需重新登录）
- 截图、获取页面无障碍树、执行 JS、点击、输入文字、导航
- 直接 WebSocket 连接，无 Puppeteer 依赖，支持 100+ 标签页

**前置条件：**
- Node.js 22+
- Chrome 开启远程调试：打开 `chrome://inspect/#remote-debugging` 并开启开关

**快速上手：**

```bash
# 列出所有打开的标签页
scripts/cdp.mjs list

# 截图（target 是 list 输出的 ID 前缀，如 6BE827FA）
scripts/cdp.mjs shot <target>

# 获取页面无障碍树（比 html 更适合理解页面结构）
scripts/cdp.mjs snap <target>

# 在页面中执行 JS
scripts/cdp.mjs eval <target> "document.title"

# 点击元素
scripts/cdp.mjs click <target> "button.submit"

# 在输入框输入文字（先 click 聚焦，再 type）
scripts/cdp.mjs type <target> "hello world"

# 导航到 URL
scripts/cdp.mjs nav <target> "https://example.com"
```

**所有命令：**

| 命令 | 说明 |
|------|------|
| `list` | 列出所有打开的页面 |
| `shot <target> [file]` | 截图（默认保存到运行时目录） |
| `snap <target>` | 页面无障碍树快照 |
| `eval <target> <expr>` | 执行 JavaScript |
| `html <target> [selector]` | 获取页面/元素 HTML |
| `nav <target> <url>` | 导航到 URL |
| `net <target>` | 网络性能分析 |
| `click <target> <selector>` | CSS 选择器点击 |
| `clickxy <target> <x> <y>` | 坐标点击（CSS 像素） |
| `type <target> <text>` | 输入文字（支持跨域 iframe） |
| `loadall <target> <selector> [ms]` | 反复点击"加载更多"直到消失 |
| `evalraw <target> <method> [json]` | 发送原始 CDP 命令 |
| `open [url]` | 打开新标签页 |
| `stop [target]` | 停止后台守护进程 |

**坐标系说明：** 截图使用设备原始分辨率（图片像素 = CSS 像素 × DPR）。`clickxy` 等输入事件使用 CSS 像素。Retina 屏幕（DPR=2）需要将截图坐标除以 2。

> 详细文档见 [skills/chrome-cdp/SKILL.md](skills/chrome-cdp/SKILL.md)

## 项目结构

```
.claude-plugin/           # 插件市场元数据
  marketplace.json
skills/                   # 技能定义
  chrome-cdp/
    SKILL.md              # 技能描述和使用说明
    scripts/
      cdp.mjs             # CDP CLI 实现
```

## 致谢

- chrome-cdp skill 源自 [pasky/chrome-cdp-skill](https://github.com/pasky/chrome-cdp-skill)
