# memory-usage

Manage persistent memory storage.

## Usage
```bash
orchestrator memory usage [options]
```

## Options
- `--action <type>` - Action (store, retrieve, list, clear)
- `--key <key>` - Memory key
- `--value <data>` - Data to store (JSON)

## Examples
```bash
# Store memory
orchestrator memory usage --action store --key "project-config" --value '{"api": "v2"}'

# Retrieve memory
orchestrator memory usage --action retrieve --key "project-config"

# List all keys
orchestrator memory usage --action list
```
