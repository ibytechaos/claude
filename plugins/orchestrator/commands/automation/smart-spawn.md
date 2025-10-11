# smart-spawn

Intelligently spawn agents based on workload analysis.

## Usage
```bash
orchestrator automation smart-spawn [options]
```

## Options
- `--analyze` - Analyze before spawning
- `--threshold <n>` - Spawn threshold
- `--topology <type>` - Preferred topology

## Examples
```bash
# Smart spawn with analysis
orchestrator automation smart-spawn --analyze

# Set spawn threshold
orchestrator automation smart-spawn --threshold 5

# Force topology
orchestrator automation smart-spawn --topology hierarchical
```
