# neural-train

Train neural patterns from operations.

## Usage
```bash
orchestrator training neural-train [options]
```

## Options
- `--data <source>` - Training data source
- `--model <name>` - Target model
- `--epochs <n>` - Training epochs

## Examples
```bash
# Train from recent ops
orchestrator training neural-train --data recent

# Specific model
orchestrator training neural-train --model task-predictor

# Custom epochs
orchestrator training neural-train --epochs 100
```
