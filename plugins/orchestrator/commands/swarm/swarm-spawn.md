# swarm-spawn

Spawn agents in the swarm.

## Usage
```bash
orchestrator swarm spawn [options]
```

## Options
- `--type <type>` - Agent type
- `--count <n>` - Number to spawn
- `--capabilities <list>` - Agent capabilities

## Examples
```bash
orchestrator swarm spawn --type coder --count 3
orchestrator swarm spawn --type researcher --capabilities "web-search,analysis"
```
