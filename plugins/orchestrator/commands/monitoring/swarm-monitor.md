# swarm-monitor

Real-time swarm monitoring.

## Usage
```bash
orchestrator swarm monitor [options]
```

## Options
- `--interval <ms>` - Update interval
- `--metrics` - Show detailed metrics
- `--export` - Export monitoring data

## Examples
```bash
# Start monitoring
orchestrator swarm monitor

# Custom interval
orchestrator swarm monitor --interval 5000

# With metrics
orchestrator swarm monitor --metrics
```
