return {
  "folke/which-key.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    -- As an example, we will create the following mappings:
    --  * <leader>ff find files
    --  * <leader>fr show recent files
    --  * <leader>fb Foobar
    -- we'll document:
    --  * <leader>fn new file
    --  * <leader>fe edit file
    -- -- and hide <leader>1
    --
    wk.add({
      -- group renames
      { "<leader>a", group = "actions", icon = { icon = "󱐋", color = "blue" } },
      { "<leader>c", group = "code", icon = { icon = "", color = "yellow" } },
      { "<leader>C", group = "CopilotChat", icon = { icon = "", color = "grey" } },
      { "<leader>e", group = "explorer", icon = { icon = "󰙅", color = "cyan" } },
      { "<leader>f", group = "find", icon = { icon = "", color = "green" } },
      { "<leader>h", group = "harpoon", icon = { icon = "󰛢", color = "yellow" } },
      { "<leader>q", group = "quickfix", icon = { icon = "󰙵", color = "azure" } },
      { "<leader>s", group = "split", icon = { icon = "", color = "purple" } },
      { "<leader>t", group = "tabs", icon = { icon = "", color = "green" } },
      { "<leader>w", group = "window", icon = { icon = "", color = "azure" } },
      { "<leader>x", group = "diag", icon = { icon = "", color = "red" } },
    }, { prefix = "<leader>" })
  end,
  opts = {
    -- any additional options
    -- show a warning when issues were detected with your mappings
    notify = true,
  },
}
