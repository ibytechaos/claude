#!/usr/bin/env bash
# 从 external/ submodules 同步所有插件到 plugins/ 为实体文件
# 用法: ./scripts/sync-plugins.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXT="$REPO_ROOT/external"
PLUGINS="$REPO_ROOT/plugins"

check_submodule() {
  local dir="$1"
  if [ ! -d "$dir" ] || [ -z "$(ls -A "$dir" 2>/dev/null)" ]; then
    echo "  ⏭  $(basename "$dir") (submodule 未初始化，跳过)"
    return 1
  fi
  return 0
}

# 通用拷贝：把一个目录下的 skills/agents/commands/hooks 等拷贝到目标
sync_plugin_dirs() {
  local src="$1" dst="$2"
  for item in skills agents commands hooks; do
    if [ -d "$src/$item" ]; then
      rm -rf "$dst/$item"
      cp -R "$src/$item" "$dst/$item"
    fi
  done
  # 拷贝 .mcp.json（如果有）
  [ -f "$src/.mcp.json" ] && cp "$src/.mcp.json" "$dst/.mcp.json"
  # 拷贝 .claude-plugin（如果目标没有的话）
  if [ -d "$src/.claude-plugin" ] && [ ! -d "$dst/.claude-plugin" ]; then
    cp -R "$src/.claude-plugin" "$dst/.claude-plugin"
  fi
}

echo "=========================================="
echo "  同步 external/ → plugins/ (实体文件)"
echo "=========================================="
echo ""

# ── 1. everything-claude-code ──────────────────
echo "→ everything-claude-code"
SRC="$EXT/everything-claude-code"
DST="$PLUGINS/everything-claude-code"
if check_submodule "$SRC"; then
  mkdir -p "$DST"
  # 它自己就是个完整 plugin（有 .claude-plugin/plugin.json）
  rm -rf "$DST/skills" "$DST/agents" "$DST/commands" "$DST/hooks"
  cp -R "$SRC/skills" "$DST/skills"
  cp -R "$SRC/agents" "$DST/agents"
  cp -R "$SRC/commands" "$DST/commands"
  [ -d "$SRC/hooks" ] && cp -R "$SRC/hooks" "$DST/hooks"
  [ -d "$SRC/.claude-plugin" ] && { rm -rf "$DST/.claude-plugin"; cp -R "$SRC/.claude-plugin" "$DST/.claude-plugin"; }
  echo "  ✅ skills($(ls "$DST/skills" | wc -l | tr -d ' ')) agents($(ls "$DST/agents" | wc -l | tr -d ' ')) commands($(ls "$DST/commands" | wc -l | tr -d ' '))"
fi
echo ""

# ── 2. superpowers ─────────────────────────────
echo "→ superpowers"
SRC="$EXT/superpowers"
DST="$PLUGINS/superpowers"
if check_submodule "$SRC"; then
  mkdir -p "$DST"
  rm -rf "$DST/skills" "$DST/agents" "$DST/commands" "$DST/hooks"
  cp -R "$SRC/skills" "$DST/skills"
  [ -d "$SRC/agents" ] && cp -R "$SRC/agents" "$DST/agents"
  [ -d "$SRC/commands" ] && cp -R "$SRC/commands" "$DST/commands"
  [ -d "$SRC/hooks" ] && cp -R "$SRC/hooks" "$DST/hooks"
  [ -d "$SRC/.claude-plugin" ] && { rm -rf "$DST/.claude-plugin"; cp -R "$SRC/.claude-plugin" "$DST/.claude-plugin"; }
  echo "  ✅ skills($(ls "$DST/skills" | wc -l | tr -d ' ')) commands($(ls "$DST/commands" 2>/dev/null | wc -l | tr -d ' '))"
fi
echo ""

# ── 3. frontend-slides ─────────────────────────
echo "→ frontend-slides"
SRC="$EXT/frontend-slides"
DST="$PLUGINS/frontend-slides"
if check_submodule "$SRC"; then
  mkdir -p "$DST/.claude-plugin"
  # frontend-slides 没有标准 plugin 结构，它自身就是一个 skill
  rm -rf "$DST/skills"
  mkdir -p "$DST/skills/frontend-slides"
  cp "$SRC/SKILL.md" "$DST/skills/frontend-slides/SKILL.md"
  cp "$SRC/STYLE_PRESETS.md" "$DST/skills/frontend-slides/STYLE_PRESETS.md"
  cp "$SRC/html-template.md" "$DST/skills/frontend-slides/html-template.md"
  cp "$SRC/animation-patterns.md" "$DST/skills/frontend-slides/animation-patterns.md"
  cp "$SRC/viewport-base.css" "$DST/skills/frontend-slides/viewport-base.css"
  cp -R "$SRC/scripts" "$DST/skills/frontend-slides/scripts" 2>/dev/null || true
  # 生成 plugin.json
  cat > "$DST/.claude-plugin/plugin.json" << 'PJSON'
{
  "name": "frontend-slides",
  "description": "HTML presentation generator — 12 themes, animations, PDF export",
  "version": "1.0.0",
  "author": { "name": "zarazhangrui" },
  "repository": "https://github.com/zarazhangrui/frontend-slides",
  "license": "MIT",
  "keywords": ["skills", "slides", "presentation", "html"]
}
PJSON
  echo "  ✅ skills/frontend-slides (SKILL.md + assets)"
fi
echo ""

# ── 4. claude-hud ──────────────────────────────
echo "→ claude-hud"
SRC="$EXT/claude-hud"
DST="$PLUGINS/claude-hud"
if check_submodule "$SRC"; then
  mkdir -p "$DST"
  rm -rf "$DST/commands" "$DST/dist" "$DST/src"
  [ -d "$SRC/commands" ] && cp -R "$SRC/commands" "$DST/commands"
  [ -d "$SRC/dist" ] && cp -R "$SRC/dist" "$DST/dist"
  [ -d "$SRC/src" ] && cp -R "$SRC/src" "$DST/src"
  [ -f "$SRC/package.json" ] && cp "$SRC/package.json" "$DST/package.json"
  [ -d "$SRC/.claude-plugin" ] && { rm -rf "$DST/.claude-plugin"; cp -R "$SRC/.claude-plugin" "$DST/.claude-plugin"; }
  echo "  ✅ commands($(ls "$DST/commands" 2>/dev/null | wc -l | tr -d ' ')) + dist + src"
fi
echo ""

# ── 5. gitnexus ────────────────────────────────
echo "→ gitnexus"
SRC="$EXT/gitnexus/gitnexus-claude-plugin"
DST="$PLUGINS/gitnexus"
if [ -d "$SRC" ]; then
  mkdir -p "$DST"
  sync_plugin_dirs "$SRC" "$DST"
  # 也拷贝 CLI 工具
  if [ -d "$EXT/gitnexus/gitnexus" ]; then
    rm -rf "$DST/gitnexus-cli"
    cp -R "$EXT/gitnexus/gitnexus" "$DST/gitnexus-cli"
  fi
  echo "  ✅ skills($(ls "$DST/skills" 2>/dev/null | wc -l | tr -d ' ')) + cli"
else
  echo "  ⏭  gitnexus (submodule 未初始化或无 claude-plugin)"
fi
echo ""

# ── 6. ui-ux-pro-max-skill ────────────────────
echo "→ ui-ux-pro-max"
SRC="$EXT/ui-ux-pro-max-skill"
DST="$PLUGINS/ui-ux-pro-max"
if check_submodule "$SRC"; then
  mkdir -p "$DST/.claude-plugin" "$DST/skills"
  rm -rf "$DST/skills/ui-ux-pro-max" "$DST/src"
  [ -d "$SRC/src/ui-ux-pro-max" ] && cp -R "$SRC/src/ui-ux-pro-max" "$DST/skills/ui-ux-pro-max"
  [ -d "$SRC/src" ] && cp -R "$SRC/src" "$DST/src"
  [ -f "$SRC/skill.json" ] && cp "$SRC/skill.json" "$DST/.claude-plugin/plugin.json"
  echo "  ✅ skills/ui-ux-pro-max"
fi
echo ""

# ── 7. context7 ────────────────────────────────
echo "→ context7"
SRC="$EXT/context7"
DST="$PLUGINS/context7"
if check_submodule "$SRC"; then
  mkdir -p "$DST"
  # 从 context7 自带的 claude plugin 结构拷贝
  PLUGIN_SRC="$SRC/plugins/claude/context7"
  if [ -d "$PLUGIN_SRC" ]; then
    rm -rf "$DST/skills" "$DST/agents" "$DST/commands" "$DST/.mcp.json"
    sync_plugin_dirs "$PLUGIN_SRC" "$DST"
    [ -f "$PLUGIN_SRC/README.md" ] && cp "$PLUGIN_SRC/README.md" "$DST/README.md"
    echo "  ✅ 基础结构 (skills/agents/commands/.mcp.json)"
  fi
  # 补充顶层 skills 中有但 plugin 里没带的
  for skill_dir in "$SRC/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    if [ ! -d "$DST/skills/$skill_name" ]; then
      cp -R "$skill_dir" "$DST/skills/$skill_name"
      echo "  ✅ 补充 skill: $skill_name"
    fi
  done
fi
echo ""

echo "=========================================="
echo "  ✅ 全部同步完成"
echo "=========================================="
echo ""
echo "ℹ️  请运行 git add plugins/ && git status 检查变更"
