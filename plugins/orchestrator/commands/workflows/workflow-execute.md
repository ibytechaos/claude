# workflow-execute

Execute saved workflows.

## Usage
```bash
orchestrator workflow execute [options]
```

## Options
- `--name <name>` - Workflow name
- `--params <json>` - Workflow parameters
- `--dry-run` - Preview execution

## Examples
```bash
# Execute workflow
orchestrator workflow execute --name "deploy-api"

# With parameters
orchestrator workflow execute --name "test-suite" --params '{"env": "staging"}'

# Dry run
orchestrator workflow execute --name "deploy-api" --dry-run
```
