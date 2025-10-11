# workflow-select

Automatically select optimal workflow based on task type.

## Usage
```bash
orchestrator automation workflow-select [options]
```

## Options
- `--task <description>` - Task description
- `--constraints <list>` - Workflow constraints
- `--preview` - Preview without executing

## Examples
```bash
# Select workflow for task
orchestrator automation workflow-select --task "Deploy to production"

# With constraints
orchestrator automation workflow-select --constraints "no-downtime,rollback"

# Preview mode
orchestrator automation workflow-select --task "Database migration" --preview
```
