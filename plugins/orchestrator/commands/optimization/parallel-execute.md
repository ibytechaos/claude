# parallel-execute

Execute tasks in parallel for maximum efficiency.

## Usage
```bash
orchestrator optimization parallel-execute [options]
```

## Options
- `--tasks <file>` - Task list file
- `--max-parallel <n>` - Maximum parallel tasks
- `--strategy <type>` - Execution strategy

## Examples
```bash
# Execute task list
orchestrator optimization parallel-execute --tasks tasks.json

# Limit parallelism
orchestrator optimization parallel-execute --tasks tasks.json --max-parallel 5

# Custom strategy
orchestrator optimization parallel-execute --strategy adaptive
```
