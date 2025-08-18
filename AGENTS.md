# Agent Guidelines for .dotfiles

## Setup Commands
- Install dependencies: `brew install stow`
- Apply all configs: `stow */`
- Apply single config: `stow nvim` (or any package name)

## Code Style & Formatting
- **Lua**: Use stylua with 2-space indents, 120-char width
- **Shell**: Follow existing zsh patterns, use descriptive comments
- **Config files**: Maintain existing indentation and structure
- **Naming**: Use snake_case for functions, kebab-case for files

## Lua Conventions (nvim configs)
- Use `local` for all variables unless global needed
- Prefer `vim.opt` over `vim.o` for options
- Use descriptive function names like `set_background_based_dark_mode`
- Group related configs in separate files under `lua/plugins/`
- Comment complex autocmd logic clearly

## File Organization
- Each tool has its own directory (nvim/, tmux/, zsh/, etc.)
- Config files follow XDG Base Directory specification
- Symlinks managed via GNU Stow
- Keep dotfiles repo structure flat for stow compatibility

No test commands needed - this is a configuration-only repository.