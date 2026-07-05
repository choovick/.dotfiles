return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "VeryLazy",
  -- Run `:Copilot auth` once after install (see plugin README); avoid `build` so updates do not re-trigger auth.
  opts = {
    panel = { enabled = false },
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
    filetypes = {
      markdown = true,
      yaml = true,
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          return false
        end
        return true
      end,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)

    local group = vim.api.nvim_create_augroup("CopilotBlinkCmp", { clear = true })

    -- blink.cmp recipe: hide ghost text while the completion menu is open
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        require("copilot.suggestion").dismiss()
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

    -- blink.cmp re-applies its insert keymaps on every InsertEnter (see blink keymap/init.lua).
    -- Re-register copilot accept keys after blink finishes (schedule = runs after this event batch).
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group,
      callback = function(args)
        local bufnr = args.buf
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          local client = require("copilot.client")
          if client.buf_is_attached(bufnr) then
            require("copilot.suggestion").set_keymap(bufnr)
          end
        end)
      end,
    })

    -- Safety net when the menu closes without BlinkCmpMenuClose (e.g. some cancel paths)
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group,
      callback = function()
        if pcall(require, "blink.cmp") and not require("blink.cmp").is_menu_visible() then
          vim.b.copilot_suggestion_hidden = false
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>or",
      function()
        vim.b.copilot_suggestion_hidden = false
        local client = require("copilot.client")
        local bufnr = vim.api.nvim_get_current_buf()
        if client.buf_is_attached(bufnr) then
          require("copilot.suggestion").set_keymap(bufnr)
          require("copilot.suggestion").update_preview()
        else
          vim.cmd("Copilot enable")
        end
      end,
      desc = "Refresh Copilot suggestions",
    },
  },
}
