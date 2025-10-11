# swarm

Main swarm orchestration command for Claude Flow.

## Usage
```bash
orchestrator swarm <objective> [options]
```

## Options
- `--strategy <type>` - Execution strategy (research, development, analysis, testing)
- `--mode <type>` - Coordination mode (centralized, distributed, hierarchical, mesh)
- `--max-agents <n>` - Maximum number of agents (default: 5)
- `--claude` - Open Claude Code CLI with swarm prompt
- `--parallel` - Enable parallel execution

## Examples
```bash
# Basic swarm
orchestrator swarm "Build REST API"

# With strategy
orchestrator swarm "Research AI patterns" --strategy research

# Open in Claude Code
orchestrator swarm "Build API" --claude
```
