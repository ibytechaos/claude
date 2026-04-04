# Claude Code Skills Collection

A collection of Claude Code skills/plugins.

## Skills

### chrome-cdp
Lightweight Chrome DevTools Protocol CLI. Connects directly to your live Chrome session via WebSocket — no Puppeteer, works with 100+ tabs, instant connection.

**Prerequisites:**
- Chrome with remote debugging enabled: `chrome://inspect/#remote-debugging`
- Node.js 22+

**Usage:** See `plugins/chrome-cdp/skills/chrome-cdp/SKILL.md` for full command reference.

### context7
Context7 MCP — 实时获取最新库文档、API 参考和代码示例。解决 LLM 训练数据过时的问题，直接从源仓库拉取当前文档。

**Skills:**
- `context7-mcp` — MCP 工具调用（resolve-library-id / query-docs）
- `find-docs` — 通过 ctx7 CLI 查询文档
- `context7-cli` — ctx7 CLI 完整命令参考

**MCP Tools:**
- `resolve-library-id` — 将库名解析为 Context7 ID
- `query-docs` — 根据库 ID 获取相关文档和代码示例

**Usage:** 询问任何库/框架的用法时自动触发，也可通过 `ctx7` CLI 手动查询。

## Project Structure

```
.claude-plugin/                    # Marketplace metadata
  marketplace.json
plugins/
  chrome-cdp/                      # chrome-cdp plugin
    .claude-plugin/plugin.json     # Plugin manifest
    skills/chrome-cdp/
      SKILL.md
      scripts/cdp.mjs
  context7/                        # context7 plugin
    .claude-plugin/plugin.json
    skills/
      context7-mcp/SKILL.md
      context7-cli/SKILL.md
      find-docs/SKILL.md
external/
  context7/                        # upstash/context7 submodule
```
