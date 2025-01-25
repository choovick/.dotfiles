return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#default-options
    -- calling `setup` is optional for customization
    local actions = require("fzf-lua").actions
    require("fzf-lua").setup({
      keymap = {
        fzf = {
          -- sets filtered items to quickfix list
          ["CTRL-q"] = "select-all+accept",
        },
      },
      grep = {
        rg_opts = "--hidden --follow --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      },
      files = {
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["ctrl-h"] = { actions.toggle_hidden },
        },
      },
      winopts = {
        fullscreen = true,
        preview = {
          -- default = "bat",
          horizontal = "right:40%",
        },
      },
    })
  end,
}
