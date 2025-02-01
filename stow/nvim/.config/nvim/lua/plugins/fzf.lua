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
          ["enter"] = "accept",
          ["ctrl-a"] = "select-all",
          ["ctrl-t"] = "toggle-all",
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
      actions = {
        ["files"] = {
          -- dont want to open multiple files in quickfix list, just edit them all on multiselect
          ["enter"] = actions.file_edit,
          ["ctrl-q"] = actions.file_sel_to_qf,

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
