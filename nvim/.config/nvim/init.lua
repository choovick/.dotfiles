-- reference https://www.josean.com/posts/how-to-setup-neovim-2024
require("config.keymaps")
require("config.options")

-- Load native LSP configuration early (before Lazy.nvim)
require("config.lsp")

require("config.lazy")
