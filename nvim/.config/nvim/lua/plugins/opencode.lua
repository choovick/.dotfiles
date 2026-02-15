-- Copy code reference from visual selection with line numbers and git-relative file path
-- @param include_content boolean: if true, includes actual code content; if false, only metadata with cursor position
local function copy_code_reference(include_content)
  -- Get visual selection range
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Get file path relative to git root
  local file_path = vim.fn.expand("%:p")
  local git_root =
    vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]

  if git_root and git_root ~= "" then
    file_path = vim.fn.fnamemodify(file_path, ":s?" .. git_root .. "/??")
  else
    file_path = vim.fn.expand("%")
  end

  local reference
  if include_content then
    -- Format with code content
    local lines = vim.fn.getline(start_line, end_line)
    local selected_text = table.concat(lines, "\n")
    reference = string.format("```%d:%d:%s\n%s\n```", start_line, end_line, file_path, selected_text)
  else
    -- Format with cursor position only
    local cursor_line = vim.fn.line(".")
    local cursor_col = vim.fn.col(".")
    reference = string.format("%d:%d:%s (cursor %d:%d)", start_line, end_line, file_path, cursor_line, cursor_col)
  end

  -- Copy to clipboard
  vim.fn.setreg("+", reference)
  vim.fn.setreg('"', reference)

  vim.notify("Copied: " .. (include_content and "reference with content" or reference), vim.log.levels.INFO)
end

return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
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
    { '<leader>oy', function() copy_code_reference(false) end, desc = 'Copy code reference', mode = 'v', },
    { '<leader>oY', function() copy_code_reference(true) end, desc = 'Copy code reference with content', mode = 'v', },
    { '<M-u>', function() require('opencode').command('session.half.page.up') end, desc = 'Scroll messages up', mode = { 'n', 'i', 't' }, },
    { '<M-d>', function() require('opencode').command('session.half.page.down') end, desc = 'Scroll messages down', mode = { 'n', 'i', 't' }, },
  },
}
