#!/usr/bin/env bash
# 从 external/context7 submodule 同步最新文件到 plugins/context7
# 用法: ./scripts/sync-context7.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/external/context7"
DST="$REPO_ROOT/plugins/context7"

if [ ! -d "$SRC/.git" ] && [ ! -f "$SRC/.git" ]; then
  echo "❌ submodule external/context7 不存在，先运行: git submodule update --init"
  exit 1
fi

echo "→ 同步 context7 plugin..."

# 清理旧文件（保留 .claude-plugin 不动，用我们自己的 plugin.json）
rm -rf "$DST/skills" "$DST/agents" "$DST/commands" "$DST/README.md" "$DST/.mcp.json"

# 从 context7 自带的 claude plugin 结构拷贝
PLUGIN_SRC="$SRC/plugins/claude/context7"
if [ -d "$PLUGIN_SRC" ]; then
  cp -R "$PLUGIN_SRC/skills" "$DST/skills" 2>/dev/null || true
  cp -R "$PLUGIN_SRC/agents" "$DST/agents" 2>/dev/null || true
  cp -R "$PLUGIN_SRC/commands" "$DST/commands" 2>/dev/null || true
  cp "$PLUGIN_SRC/README.md" "$DST/README.md" 2>/dev/null || true
  cp "$PLUGIN_SRC/.mcp.json" "$DST/.mcp.json" 2>/dev/null || true
  echo "  ✅ 基础结构 (skills/agents/commands/.mcp.json)"
fi

# 补充 context7 顶层 skills 中有但 plugin 里没带的
for skill_dir in "$SRC/skills/"*/; do
  skill_name="$(basename "$skill_dir")"
  if [ ! -d "$DST/skills/$skill_name" ]; then
    cp -R "$skill_dir" "$DST/skills/$skill_name"
    echo "  ✅ 补充 skill: $skill_name"
  fi
done

echo "✅ context7 同步完成"
