# Claude Code Skills Collection

A collection of Claude Code skills/plugins.

## Skills

### chrome-cdp
Lightweight Chrome DevTools Protocol CLI. Connects directly to your live Chrome session via WebSocket — no Puppeteer, works with 100+ tabs, instant connection.

**Prerequisites:**
- Chrome with remote debugging enabled: `chrome://inspect/#remote-debugging`
- Node.js 22+

**Usage:** See `plugins/chrome-cdp/skills/chrome-cdp/SKILL.md` for full command reference.

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
```
