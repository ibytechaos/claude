# workflow-export

Export workflows for sharing.

## Usage
```bash
orchestrator workflow export [options]
```

## Options
- `--name <name>` - Workflow to export
- `--format <type>` - Export format
- `--include-history` - Include execution history

## Examples
```bash
# Export workflow
orchestrator workflow export --name "deploy-api"

# As YAML
orchestrator workflow export --name "test-suite" --format yaml

# With history
orchestrator workflow export --name "deploy-api" --include-history
```
