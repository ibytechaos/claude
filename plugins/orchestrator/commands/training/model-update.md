# model-update

Update neural models with new data.

## Usage
```bash
orchestrator training model-update [options]
```

## Options
- `--model <name>` - Model to update
- `--incremental` - Incremental update
- `--validate` - Validate after update

## Examples
```bash
# Update all models
orchestrator training model-update

# Specific model
orchestrator training model-update --model agent-selector

# Incremental with validation
orchestrator training model-update --incremental --validate
```
