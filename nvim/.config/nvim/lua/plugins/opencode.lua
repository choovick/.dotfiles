return {
  'NickvanDyke/opencode.nvim',
  dependencies = { 'folke/snacks.nvim', },
  config = function()
    -- Set options via vim.g.opencode_opts as recommended
    -- New machine setup note (Codex auth bridge):
    -- https://github.com/numman-ali/opencode-openai-codex-auth
    -- Install: npx -y opencode-openai-codex-auth@latest
    -- Login: opencode auth login
    -- Optional cleanup: npx -y opencode-openai-codex-auth@latest --uninstall
    vim.g.opencode_opts = {
      -- https://github.com/NickvanDyke/opencode.nvim/blob/main/lua/opencode/config.lua
    }
  end,
  -- stylua: ignore
  keys = {
    { '<leader>oo', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>op', function() require('opencode').select() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>on', function() require('opencode').command('session.new') end, desc = 'New session', },
    { '<leader>os', function() require('opencode').select_server() end, desc = 'Select server', },
    { '<leader>oS', function() require('opencode').select_session() end, desc = 'Select session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<M-u>', function() require('opencode').command('session.half.page.up') end, desc = 'Scroll messages up', mode = { 'n', 'i', 't' }, },
    { '<M-d>', function() require('opencode').command('session.half.page.down') end, desc = 'Scroll messages down', mode = { 'n', 'i', 't' }, },
  },
}
