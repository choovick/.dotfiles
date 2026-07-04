local parsers = {
  "bash",
  "zsh",
  "yaml",
  "terraform",
  "graphql",
  "helm",
  "python",
  "javascript",
  "html",
  "json",
}

local function install_parsers()
  require("nvim-treesitter").install(parsers)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = { "williamboman/mason.nvim" },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      install_parsers()

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
