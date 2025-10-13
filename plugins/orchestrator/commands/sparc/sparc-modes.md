# SPARC Modes Overview

SPARC (Specification, Planning, Architecture, Review, Code) is a comprehensive development methodology with 17 specialized modes, all integrated with MCP tools for enhanced coordination and execution.

## Available Modes

### Core Orchestration Modes
- **orchestrator**: Multi-agent task orchestration
- **swarm-coordinator**: Specialized swarm management
- **workflow-manager**: Process automation
- **batch-executor**: Parallel task execution

### Development Modes  
- **coder**: Autonomous code generation
- **architect**: System design
- **reviewer**: Code review
- **tdd**: Test-driven development

### Analysis and Research Modes
- **researcher**: Deep research capabilities
- **analyzer**: Code and data analysis
- **optimizer**: Performance optimization

### Creative and Support Modes
- **designer**: UI/UX design
- **innovator**: Creative problem solving
- **documenter**: Documentation generation
- **debugger**: Systematic debugging
- **tester**: Comprehensive testing
- **memory-manager**: Knowledge management

## Usage

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
// Execute SPARC mode directly
mcp__orchestrator__sparc_mode {
  mode: "<mode>",
  task_description: "<task>",
  options: {
    // mode-specific options
  }
}

// Initialize swarm for advanced coordination
mcp__orchestrator__swarm_init {
  topology: "hierarchical",
  strategy: "auto",
  maxAgents: 8
}

// Spawn specialized agents
mcp__orchestrator__agent_spawn {
  type: "<agent-type>",
  capabilities: ["<capability1>", "<capability2>"]
}

// Monitor execution
mcp__orchestrator__swarm_monitor {
  swarmId: "current",
  interval: 5000
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
orchestrator sparc run <mode> "task description"

# For alpha features
orchestrator sparc run <mode> "task description"

# List all modes
orchestrator sparc modes

# Get help for a mode
orchestrator sparc help <mode>

# Run with options
orchestrator sparc run <mode> "task" --parallel --monitor
```

### Option 3: Local Installation
```bash
# If orchestrator is installed locally
./orchestrator sparc run <mode> "task description"
```

## Common Workflows

### Full Development Cycle

#### Using MCP Tools (Preferred)
```javascript
// 1. Initialize development swarm
mcp__orchestrator__swarm_init {
  topology: "hierarchical",
  maxAgents: 12
}

// 2. Architecture design
mcp__orchestrator__sparc_mode {
  mode: "architect",
  task_description: "design microservices"
}

// 3. Implementation
mcp__orchestrator__sparc_mode {
  mode: "coder",
  task_description: "implement services"
}

// 4. Testing
mcp__orchestrator__sparc_mode {
  mode: "tdd",
  task_description: "test all services"
}

// 5. Review
mcp__orchestrator__sparc_mode {
  mode: "reviewer",
  task_description: "review implementation"
}
```

#### Using NPX CLI (Fallback)
```bash
# 1. Architecture design
orchestrator sparc run architect "design microservices"

# 2. Implementation
orchestrator sparc run coder "implement services"

# 3. Testing
orchestrator sparc run tdd "test all services"

# 4. Review
orchestrator sparc run reviewer "review implementation"
```

### Research and Innovation

#### Using MCP Tools (Preferred)
```javascript
// 1. Research phase
mcp__orchestrator__sparc_mode {
  mode: "researcher",
  task_description: "research best practices"
}

// 2. Innovation
mcp__orchestrator__sparc_mode {
  mode: "innovator",
  task_description: "propose novel solutions"
}

// 3. Documentation
mcp__orchestrator__sparc_mode {
  mode: "documenter",
  task_description: "document findings"
}
```

#### Using NPX CLI (Fallback)
```bash
# 1. Research phase
orchestrator sparc run researcher "research best practices"

# 2. Innovation
orchestrator sparc run innovator "propose novel solutions"

# 3. Documentation
orchestrator sparc run documenter "document findings"
```
