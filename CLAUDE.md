# Claude Code Skills Collection

A collection of Claude Code skills/plugins.

## Skills

### chrome-cdp
Lightweight Chrome DevTools Protocol CLI. Connects directly to your live Chrome session via WebSocket — no Puppeteer, works with 100+ tabs, instant connection.

**Prerequisites:**
- Chrome with remote debugging enabled: `chrome://inspect/#remote-debugging`
- Node.js 22+

**Usage:** See `skills/chrome-cdp/SKILL.md` for full command reference.

## Project Structure

```
.claude-plugin/       # Plugin marketplace metadata
  marketplace.json
skills/               # Skill definitions
  chrome-cdp/
    SKILL.md          # Skill description and usage
    scripts/
      cdp.mjs         # CDP CLI implementation
```
