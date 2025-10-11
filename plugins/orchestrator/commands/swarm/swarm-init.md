# swarm-init

Initialize a new swarm with specified topology.

## Usage
```bash
orchestrator swarm init [options]
```

## Options
- `--topology <type>` - Swarm topology (mesh, hierarchical, ring, star)
- `--max-agents <n>` - Maximum agents
- `--strategy <type>` - Distribution strategy

## Examples
```bash
orchestrator swarm init --topology mesh
orchestrator swarm init --topology hierarchical --max-agents 8
```
