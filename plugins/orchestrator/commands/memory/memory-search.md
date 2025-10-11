# memory-search

Search through stored memory.

## Usage
```bash
orchestrator memory search [options]
```

## Options
- `--query <text>` - Search query
- `--pattern <regex>` - Pattern matching
- `--limit <n>` - Result limit

## Examples
```bash
# Search memory
orchestrator memory search --query "authentication"

# Pattern search
orchestrator memory search --pattern "api-.*"

# Limited results
orchestrator memory search --query "config" --limit 10
```
