local parsers = {
  "bash",
  "zsh",
  "yaml",
  "terraform",
  "graphql",
  "helm",
  "gotmpl",
  "python",
  "javascript",
  "html",
  "json",
  "toml",
}

-- Filetypes that use a treesitter parser but are not named after it.
-- ghostty: parser built by bezhermoso/tree-sitter-ghostty (see plugins/ghostty.lua)
local highlight_filetypes = vim.list_extend({ "terraform-vars", "ghostty" }, parsers)

local function install_parsers()
  require("nvim-treesitter").install(parsers)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "williamboman/mason.nvim",
      "bezhermoso/tree-sitter-ghostty",
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      install_parsers()

      -- Neovim 0.12: treesitter highlighting is opt-in per filetype.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = highlight_filetypes,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- No runtime syntax/terraform-vars.vim; reuse HCL rules as fallback.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "terraform-vars",
        callback = function()
          if vim.fn.exists("b:current_syntax") == 0 then
            vim.cmd.runtime("syntax/terraform.vim")
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = install_parsers,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
