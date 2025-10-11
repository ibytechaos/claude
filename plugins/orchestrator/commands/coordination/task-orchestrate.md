# task-orchestrate

Orchestrate complex tasks across the swarm.

## Usage
```bash
orchestrator task orchestrate [options]
```

## Options
- `--task <description>` - Task description
- `--strategy <type>` - Orchestration strategy
- `--priority <level>` - Task priority (low, medium, high, critical)

## Examples
```bash
# Orchestrate development task
orchestrator task orchestrate --task "Implement user authentication"

# High priority task
orchestrator task orchestrate --task "Fix production bug" --priority critical

# With specific strategy
orchestrator task orchestrate --task "Refactor codebase" --strategy parallel
```
