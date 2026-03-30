# ibytechaos/claude — Claude Code 配置分发中心
# 精品 skills/plugins/MCP 的集中管理与一键同步

CLAUDE_HOME := $(HOME)/.claude
CLAUDE_JSON := $(HOME)/.claude.json

.PHONY: help install sync-project list update assemble clean

help: ## 显示帮助
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ── 安装 ─────────────────────────────────────────
install: assemble ## 一键安装：组装精品 → 安装到 ~/.claude
	@echo "→ 安装 skills 到 ~/.claude/skills/"
	@mkdir -p $(CLAUDE_HOME)/skills
	@for d in dist/skills/*/; do \
		name=$$(basename "$$d"); \
		if [ -d "$(CLAUDE_HOME)/skills/$$name" ]; then \
			echo "  ⏭  $$name (已存在，跳过)"; \
		else \
			cp -r "$$d" "$(CLAUDE_HOME)/skills/$$name"; \
			echo "  ✅ $$name"; \
		fi; \
	done
	@echo ""
	@echo "→ MCP 全局配置请手动合并 mcp/global.json 到 ~/.claude.json"
	@echo "  （自动合并有覆盖风险，建议手动检查）"
	@echo ""
	@echo "✅ 安装完成。重启 Claude Code 生效。"

assemble: ## 从 external/ 组装精品到 dist/
	@echo "→ 组装精品 skills..."
	@rm -rf dist/skills
	@mkdir -p dist/skills
	@# 自有 skills
	@for d in plugins/*/skills/*/; do \
		name=$$(basename "$$d"); \
		cp -r "$$d" "dist/skills/$$name"; \
	done
	@# frontend-slides
	@if [ -d "external/frontend-slides" ]; then \
		mkdir -p dist/skills/frontend-slides; \
		cp external/frontend-slides/SKILL.md dist/skills/frontend-slides/; \
		cp external/frontend-slides/STYLE_PRESETS.md dist/skills/frontend-slides/; \
		cp external/frontend-slides/html-template.md dist/skills/frontend-slides/; \
		cp external/frontend-slides/animation-patterns.md dist/skills/frontend-slides/; \
		cp external/frontend-slides/viewport-base.css dist/skills/frontend-slides/; \
		cp -r external/frontend-slides/scripts dist/skills/frontend-slides/scripts 2>/dev/null || true; \
		echo "  ✅ frontend-slides"; \
	fi
	@# everything-claude-code 精选 skills
	@if [ -d "external/everything-claude-code/skills" ]; then \
		for s in tdd-workflow security-review code-review verification-loop agentic-engineering \
		         continuous-learning deep-research search-first repo-scan codebase-onboarding \
		         api-design architecture-decision-records rust-patterns rust-testing \
		         python-patterns python-testing git-workflow; do \
			if [ -d "external/everything-claude-code/skills/$$s" ]; then \
				cp -r "external/everything-claude-code/skills/$$s" "dist/skills/$$s"; \
				echo "  ✅ $$s (from ecc)"; \
			fi; \
		done; \
	fi
	@echo ""
	@echo "→ 组装精品 agents..."
	@rm -rf dist/agents
	@mkdir -p dist/agents
	@if [ -d "external/everything-claude-code/agents" ]; then \
		for a in code-reviewer.md security-reviewer.md architect.md planner.md \
		         tdd-guide.md performance-optimizer.md rust-reviewer.md; do \
			if [ -f "external/everything-claude-code/agents/$$a" ]; then \
				cp "external/everything-claude-code/agents/$$a" "dist/agents/$$a"; \
				echo "  ✅ $$a (from ecc)"; \
			fi; \
		done; \
	fi
	@echo ""
	@echo "→ 组装精品 hooks..."
	@rm -rf dist/hooks
	@mkdir -p dist/hooks
	@if [ -f "external/everything-claude-code/hooks/hooks.json" ]; then \
		cp "external/everything-claude-code/hooks/hooks.json" "dist/hooks/hooks.json"; \
		echo "  ✅ hooks.json (from ecc)"; \
	fi
	@echo ""
	@echo "✅ 组装完成。运行 make install 安装到系统。"

sync-project: ## 同步到项目：make sync-project PROJECT=~/Github/zerion
ifndef PROJECT
	$(error 用法: make sync-project PROJECT=~/Github/zerion)
endif
	@echo "→ 同步到 $(PROJECT)"
	@# 同步 .mcp.json
	@proj_name=$$(basename "$(PROJECT)"); \
	mcp_template="mcp/projects/$$proj_name.json"; \
	if [ -f "$$mcp_template" ]; then \
		cp "$$mcp_template" "$(PROJECT)/.mcp.json"; \
		echo "  ✅ .mcp.json (from $$mcp_template)"; \
	else \
		echo "  ⏭  .mcp.json (无模板 $$mcp_template)"; \
	fi
	@echo "  ℹ️  .claude/settings.json 和 skills 请项目自行管理"
	@echo "✅ 同步完成"

list: ## 列出已组装/已安装的内容
	@echo "=== dist/ 已组装 ==="
	@echo "Skills:"
	@ls dist/skills/ 2>/dev/null | sed 's/^/  /' || echo "  (未组装，运行 make assemble)"
	@echo "Agents:"
	@ls dist/agents/ 2>/dev/null | sed 's/^/  /' || echo "  (无)"
	@echo ""
	@echo "=== ~/.claude/skills/ 已安装 ==="
	@ls $(CLAUDE_HOME)/skills/ 2>/dev/null | sed 's/^/  /' || echo "  (无)"
	@echo ""
	@echo "=== MCP 模板 ==="
	@ls mcp/projects/ 2>/dev/null | sed 's/^/  /'

update: ## 更新 submodules
	git pull
	git submodule update --remote --merge
	@echo "✅ 子模块已更新"

clean: ## 清理组装产物
	rm -rf dist/
	@echo "✅ 已清理"
