# mcpsmgr

MCP server definitions managed by [mcpsmgr](https://github.com/jtianling/mcps-manager),
stowed into `$HOME` via [GNU Stow](https://www.gnu.org/software/stow/).

This package defines all MCP servers in one canonical manifest (`mcp-manifest.json`),
then uses `mcpsmgr` to deploy them to any AI agent (Claude Code, Cursor, Codex, etc.)
in each agent's native config format — with automatic schema translation.

## Files

| File | Stows to | Purpose |
|------|----------|---------|
| `mcp-manifest.json` | `~/mcp-manifest.json` | Canonical server definitions (no secrets — uses `${VAR}` references) |

## What is NOT stowed (stays local)

| Path | Why |
|------|-----|
| `~/.mcps-manager/` | Central repo with resolved credentials. **Never commit this.** |
| `~/.claude.json`, `~/.cursor/mcp.json`, `~/.codex/config.toml` | Per-client deployed configs (managed by their own stow packages or written by `mcpsmgr deploy`) |

## Prerequisites

```bash
# GNU Stow (if not already installed)
brew install stow

# mcpsmgr
npm install -g mcpsmgr
```

Other tools needed by the servers in this manifest:
- **Docker** — for the terraform MCP server (`docker ps` should work)
- **Node.js 18+** — for npx-based servers (jira)
- **Jira API token** — create at https://id.atlassian.com/manage-profile/security/api-tokens

## Setup

### 1. Stow this package

From the dotfiles repo root:

```bash
cd ~/.dotfiles
stow mcpsmgr
```

This creates the symlink `~/mcp-manifest.json → ~/.dotfiles/mcpsmgr/mcp-manifest.json`.

### 2. Install servers into the central repo

```bash
npx mcpsmgr install ~/mcp-manifest.json
```

This reads the manifest and registers all servers in `~/.mcps-manager/servers/`.
You'll be prompted for any required variables (Jira email, API token, domain).

**Non-interactive alternative** (for CI or scripting):

```bash
npx mcpsmgr install ~/mcp-manifest.json \
  --var JIRA_EMAIL=you@company.com \
  --var JIRA_API_TOKEN=ATATT3xF... \
  --var JIRA_DOMAIN=company.atlassian.net \
  -y
```

### 3. Verify

```bash
npx mcpsmgr list
```

Should show all servers registered in the central repo.

## Deploy to a project

From any project where you want the MCP servers available:

```bash
cd ~/dev/your-project
npx mcpsmgr deploy
```

`deploy` **autodetects** which agents the project already uses (by looking for
`.mcp.json`, `.codex/`, `.cursor/`, etc.) and writes to all of them in their
native format:

| Agent | Config file | Format |
|-------|-------------|--------|
| Claude Code | `.mcp.json` | JSON (`"type":"http"` for HTTP servers) |
| Cursor | `.cursor/mcp.json` | JSON (bare `"url"` for HTTP servers) |
| Codex | `.codex/config.toml` | TOML (`enabled = true` per server) |
| Gemini CLI | `.gemini/settings.json` | JSON |
| OpenCode | `opencode.json` | JSON |
| Windsurf | `.codeium/windsurf/mcp_config.json` | JSON |
| Kimi Code | `.kimi-code/mcp.json` | JSON (with `transport` discriminator) |

Verify the deployment:

```bash
npx mcpsmgr list --deployed
```

## Update after editing the manifest

If you edit `mcp-manifest.json` (add servers, pin versions, change config):

```bash
# 1. Re-sync the central repo from the manifest
npx mcpsmgr update

# 2. Re-deploy to each project
cd ~/dev/your-project
npx mcpsmgr deploy --refresh
```

## Add a new server

Edit `mcp-manifest.json` and add a new entry under `agents.claude-code.servers[]`:

```json
{
  "name": "my-new-server",
  "config": {
    "transport": "stdio",
    "command": "npx",
    "args": ["-y", "some-mcp-package"],
    "env": {
      "API_KEY": "${API_KEY}"
    }
  }
}
```

If the server needs secrets, declare them as variables at the top of the manifest:

```json
"variables": {
  "API_KEY": {
    "default": "",
    "prompt": "API key for my-new-server",
    "required": true
  }
}
```

Then update and redeploy:

```bash
npx mcpsmgr update
cd ~/dev/your-project && npx mcpsmgr deploy --refresh
```

## Remove a server

```bash
# Remove from current project only
npx mcpsmgr remove my-new-server

# Remove from central repo entirely (unavailable for future deploys)
npx mcpsmgr uninstall my-new-server
```

Then delete the entry from `mcp-manifest.json` and commit.

## Servers currently defined

| Name | Transport | Command | Notes |
|------|-----------|---------|-------|
| terraform | stdio | `docker run -i --rm hashicorp/terraform-mcp-server:latest` | HashiCorp official Terraform MCP |
| context7 | http | `https://mcp.context7.com/mcp` | Library documentation lookup |
| jira | stdio | `npx -y jira-server` | [cfdude/mcp-jira](https://github.com/cfdude/mcp-jira) — needs Jira Cloud creds |

## Security notes

- The manifest uses `${VAR}` references for secrets — **no plaintext secrets in this file**.
- `npx mcpsmgr install` resolves the variables and stores the actual values in
  `~/.mcps-manager/servers/*.json` in **plaintext**. This directory is gitignored
  (see `.dotfiles/.gitignore`) and never committed.
- Deployed per-client configs (`.mcp.json`, `.codex/config.toml`, etc.) also contain
  plaintext secrets. Restrict permissions:
  ```bash
  chmod 700 ~/.mcps-manager
  chmod 600 ~/.mcps-manager/servers/*.json
  ```
- To rotate a credential, edit the central repo entry and re-deploy:
  ```bash
  npx mcpsmgr install ~/mcp-manifest.json --force
  npx mcpsmgr deploy --refresh
  ```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `deploy` didn't write to an agent | The project has no config file for that agent yet. Create it first (e.g. `touch .mcp.json`) or run `mcpsmgr deploy` and select the agent interactively. |
| Jira server fails to start | Check `JIRA_DOMAIN` is correct (e.g. `company.atlassian.net` without `https://`). Verify the API token is valid at https://id.atlassian.com/manage-profile/security/api-tokens. |
| terraform server fails to start | Ensure Docker is running (`docker ps`). The image will be pulled on first use. |
| context7 doesn't respond | Test the URL: `curl -I https://mcp.context7.com/mcp`. A 404/405 means the server is up (MCP endpoints only answer POST). |
| `mcpsmgr: command not found` | Run `npm install -g mcpsmgr` or use `npx mcpsmgr` instead. |

## Unstow

```bash
cd ~/.dotfiles
stow -D mcpsmgr
```

This removes the `~/mcp-manifest.json` symlink. The central repo at
`~/.mcps-manager/` is not affected.
