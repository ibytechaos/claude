# agent-metrics

View agent performance metrics.

## Usage
```bash
orchestrator agent metrics [options]
```

## Options
- `--agent-id <id>` - Specific agent
- `--period <time>` - Time period
- `--format <type>` - Output format

## Examples
```bash
# All agents metrics
orchestrator agent metrics

# Specific agent
orchestrator agent metrics --agent-id agent-001

# Last hour
orchestrator agent metrics --period 1h
```
