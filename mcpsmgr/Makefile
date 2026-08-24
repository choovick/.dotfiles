# mcpsmgr Makefile — manage MCP servers across agents
# Usage: make <target>   (run from ~/.dotfiles/mcpsmgr)

MCP_SERVERS := terraform context7 atlassian

# Ensure brew and local bins are on PATH (make uses /bin/sh by default)
export PATH := /opt/homebrew/bin:/usr/local/bin:$(HOME)/.local/bin:$(HOME)/bin:$(PATH)

.PHONY: install update deploy deploy-cursor deploy-codex deploy-claude \
        list list-deployed remove uninstall help

# === Install / Update central repo ===

install:
	npx mcpsmgr install ~/mcp-manifest.json

update:
	npx mcpsmgr update

# === Deploy to agents (user-level) ===

deploy-cursor:
	cd ~ && for srv in $(MCP_SERVERS); do npx mcpsmgr add $$srv -a cursor -y -f; done

deploy-codex:
	cd ~ && for srv in $(MCP_SERVERS); do npx mcpsmgr add $$srv -a codex --global -y -f; done

deploy-claude:
	@for srv in $(MCP_SERVERS); do \
		json=$$(jq -c '.default | del(.transport) | if .env == {} then del(.env) else . end' \
			"$$HOME/.mcps-manager/servers/$$srv.json" 2>/dev/null); \
		if [ -z "$$json" ]; then \
			echo "  skip $$srv (not in central repo)"; \
		else \
			echo "  + $$srv -> Claude Code (~/.claude.json)"; \
			jq --arg name "$$srv" --argjson config "$$json" \
				'.mcpServers[$$name] = $$config' \
				"$$HOME/.claude.json" > "$$HOME/.claude.json.tmp" \
				&& mv "$$HOME/.claude.json.tmp" "$$HOME/.claude.json"; \
		fi; \
	done

deploy: deploy-cursor deploy-codex deploy-claude
	@echo "Done. Restart your agents to pick up changes."

# === Inspect / Remove ===

list:
	npx mcpsmgr list

list-deployed:
	npx mcpsmgr list --deployed

remove:
	@read -p "Server name to remove from project: " srv; \
	npx mcpsmgr remove $$srv

uninstall:
	@read -p "Server name to uninstall from central repo: " srv; \
	npx mcpsmgr uninstall $$srv

# === Help ===

help:
	@echo "Usage: make <target>   (from ~/.dotfiles/mcpsmgr)"
	@echo ""
	@echo "Central repo:"
	@echo "  install          Install servers from manifest into central repo"
	@echo "  update           Update central repo from manifest"
	@echo "  list             List servers in central repo"
	@echo "  uninstall         Uninstall a server from central repo"
	@echo ""
	@echo "Deploy (user-level, all projects):"
	@echo "  deploy           Deploy all servers to all agents"
	@echo "  deploy-cursor    Deploy to Cursor only"
	@echo "  deploy-codex     Deploy to Codex only (global scope)"
	@echo "  deploy-claude    Deploy to Claude Code only (user scope)"
	@echo ""
	@echo "Project-level:"
	@echo "  list-deployed    List deployed servers in current project"
	@echo "  remove           Remove a server from current project"
	@echo ""
	@echo "MCP servers: $(MCP_SERVERS)"
