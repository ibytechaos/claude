# workflow-create

Create reusable workflow templates.

## Usage
```bash
orchestrator workflow create [options]
```

## Options
- `--name <name>` - Workflow name
- `--from-history` - Create from history
- `--interactive` - Interactive creation

## Examples
```bash
# Create workflow
orchestrator workflow create --name "deploy-api"

# From history
orchestrator workflow create --name "test-suite" --from-history

# Interactive mode
orchestrator workflow create --interactive
```
