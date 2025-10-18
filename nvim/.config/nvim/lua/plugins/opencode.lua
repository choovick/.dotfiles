return {
  'NickvanDyke/opencode.nvim',
  dependencies = { 'folke/snacks.nvim', },
  config = function()
    -- Set options via vim.g.opencode_opts as recommended
    vim.g.opencode_opts = {
      -- https://github.com/NickvanDyke/opencode.nvim/blob/main/lua/opencode/config.lua
    }
  end,
  -- stylua: ignore
  keys = {
    { '<leader>oo', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>oa', function() require('opencode').ask('@cursor: ', {}) end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>oa', function() require('opencode').ask('@selection: ', {}) end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<M-u>', function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', mode = { 'n', 'i', 't' }, },
    { '<M-d>', function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', mode = { 'n', 'i', 't' }, },
  },
}
