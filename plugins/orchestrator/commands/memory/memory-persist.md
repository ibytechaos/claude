# memory-persist

Persist memory across sessions.

## Usage
```bash
orchestrator memory persist [options]
```

## Options
- `--export <file>` - Export to file
- `--import <file>` - Import from file
- `--compress` - Compress memory data

## Examples
```bash
# Export memory
orchestrator memory persist --export memory-backup.json

# Import memory
orchestrator memory persist --import memory-backup.json

# Compressed export
orchestrator memory persist --export memory.gz --compress
```
