#!/bin/zsh

CURRENT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
cd "$CURRENT_DIR" && cd ..

orchestrator init --force

rm -rf plugins/orchestrator/agents
rm -rf plugins/orchestrator/commands

cp -rf .claude/agents plugins/orchestrator/
cp -rf .claude/commands plugins/orchestrator/

find plugins/orchestrator -type f -name "*.md" | xargs -I {} sed -i '' 's/npx claude-flow@alpha/orchestrator/g' {}
find plugins/orchestrator -type f -name "*.md" | xargs -I {} sed -i '' 's/npx claude-flow/orchestrator/g' {}
find plugins/orchestrator -type f -name "*.md" | xargs -I {} sed -i '' 's/claude-flow/orchestrator/g' {}
git restore .gitignore
