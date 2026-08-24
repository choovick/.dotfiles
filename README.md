# .dotfiles

## Requirements

1. GNU Stow
2. Node.js 18+ (for MCP server management)
3. jq (for Claude Code MCP deploys)

OSX install: `brew install stow jq`

## Usage

1. Clone repo to home directory if not already present

    ```bash
    git clone git@github.com:choovick/.dotfiles.git $HOME/.dotfiles
    ```

1. Change to repo directory

    ```bash
    cd $HOME/.dotfiles
    ```

1. Stow all package directories

    ```bash
    stow */
    ```

    Or stow individual packages:

    ```bash
    stow nvim
    stow zsh
    stow tmux
    # etc.
    ```

## MCP servers

MCP servers are managed by `mcpsmgr` via the `mcpsmgr/` stow package. See
`mcpsmgr/README.md` and `mcpsmgr/Makefile` for details.

```bash
cd $HOME/.dotfiles/mcpsmgr
make help        # list available targets
make install     # install servers from manifest into central repo
make deploy      # deploy all servers to all agents (Cursor, Codex, Claude Code)
```
