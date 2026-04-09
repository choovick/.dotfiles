return {
  "zbirenbaum/copilot.lua",
  -- enabled = false,
  cmd = "Copilot",
  event = "InsertEnter",
  -- Run `:Copilot auth` once after install (see plugin README); avoid `build` so updates do not re-trigger auth.
  -- Full default `setup()` options: https://github.com/zbirenbaum/copilot.lua#setup-and-configuration
  opts = {
    panel = { enabled = false },
    -- Inline ghost text; hide when blink.cmp menu is open (User autocommands from plugin README).
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      trigger_on_accept = true,
      keymap = {
        accept = "<M-l>",
        accept_word = "<M-j>",
        accept_line = "<M-k>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<M-h>",
      },
    },
    -- filetypes
    -- https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#filetypes
    filetypes = {
      markdown = true, -- overrides default
      -- terraform = false, -- disallow specific filetype
      yaml = true,
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          -- disable for .env files
          return false
        end
        return true
      end,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)

    local group = vim.api.nvim_create_augroup("CopilotBlinkCmp", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
  keys = {
    -- leader o r to disable/enable copilot in the single hotkey
    { "<leader>or", "<cmd>Copilot disable<CR><cmd>Copilot enable<CR>", desc = "Copilot Disable/Enable" },
  },
}
