# pattern-learn

Learn patterns from successful operations.

## Usage
```bash
orchestrator training pattern-learn [options]
```

## Options
- `--source <type>` - Pattern source
- `--threshold <score>` - Success threshold
- `--save <name>` - Save pattern set

## Examples
```bash
# Learn from all ops
orchestrator training pattern-learn

# High success only
orchestrator training pattern-learn --threshold 0.9

# Save patterns
orchestrator training pattern-learn --save optimal-patterns
```
