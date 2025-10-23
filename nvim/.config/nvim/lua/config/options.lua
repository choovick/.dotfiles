local opt = vim.opt -- for conciseness

-- line numbers
-- opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- word wrap
-- disable line wrapping by default
opt.wrap = false
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt.wrap = true
  end,
})

-- Add filetypes for terraform
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform-vars",
  },
})

-- Set smarty filetype for values.yaml files in terraform directories
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "**/terraform/**/values.yaml",
  callback = function()
    vim.bo.filetype = "smarty"
  end,
})

-- see non printable characters
opt.list = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swap file
opt.swapfile = false

-- change indents for markdown
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.opt.shiftwidth = 4
--     vim.opt.tabstop = 4
--   end,
-- })

-- Highlight on yank
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- delayed VimEnter function in case need something
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function()
-- 		-- Delay the execution of the update function by 1 second
-- 		vim.defer_fn(function()
-- 			-- to fix the issue with lualine picking theme based on system appearance.
-- 			print("Vim entered")
-- 		end, 1000)
-- 	end,
-- })

-- setting language to en_us
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- BACKGROUND COLOR FOR INACTIVE WINDOWS
-- Global Function to apply background color based on window state
function set_background_based_dark_mode(win_id, is_active)
  if is_active then
    -- Default background color
    vim.cmd("highlight NormalBackground guibg=NONE")
    vim.api.nvim_win_set_option(win_id, "winhl", "Normal:NormalBackground")
  else
    if vim.o.background == "dark" then
      vim.cmd("highlight InactiveBackground guibg=#424242")
    else
      vim.cmd("highlight InactiveBackground guibg=#A9A9A9")
    end
    vim.api.nvim_win_set_option(win_id, "winhl", "Normal:InactiveBackground")
  end
end

-- Set up autocommand for entering a window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    set_background_based_dark_mode(vim.api.nvim_get_current_win(), true)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= vim.api.nvim_get_current_win() then
        set_background_based_dark_mode(win, false)
      end
    end
  end,
})

-- Set up autocommand for leaving a window
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    set_background_based_dark_mode(vim.api.nvim_get_current_win(), false)
  end,
})

-- Optional: Apply the InactiveBackground on startup for inactive windows
vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= vim.api.nvim_get_current_win() then
        set_background_based_dark_mode(win, false)
      end
    end
  end,
})
-- nvim-tree window picker highlight
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd("highlight NvimTreeWindowPicker guifg=#4E4E4E guibg=#FFAF01 gui=bold")
  end,
})

-- Auto-resize nvim-tree when first non-nvim-tree buffer is opened in session
local auto_resize_triggered = false
local timer_running = false
local debug_enabled = false -- Set to true to enable debug messages
local autocmd_id = nil

local function auto_resize_nvim_tree()
  if debug_enabled then
    print("RESIZE: Called - triggered:", auto_resize_triggered, "timer_running:", timer_running)
  end

  -- If already triggered or timer is running, do nothing
  if auto_resize_triggered or timer_running then
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(current_buf)
  local buftype = vim.bo[current_buf].buftype

  if debug_enabled then
    print("RESIZE: Buffer:", buf_name, "type:", buftype)
  end

  -- Check if this is a real file (not directory, not nvim-tree, not empty)
  local is_real_file = buf_name ~= "" and
                      buftype == "" and
                      not buf_name:match("NvimTree") and
                      vim.fn.isdirectory(buf_name) == 0 and
                      vim.fn.filereadable(buf_name) == 1

  if debug_enabled then
    print("RESIZE: is_real_file:", is_real_file, "isdirectory:", vim.fn.isdirectory(buf_name), "filereadable:", vim.fn.filereadable(buf_name))
  end

  if is_real_file then
    if debug_enabled then
      print("RESIZE: Starting timer")
    end
    timer_running = true

    -- Use a timer to check if nvim-tree becomes visible
    local timer = vim.loop.new_timer()
    local attempts = 0
    local max_attempts = 10
    local timer_closed = false

    local function cleanup_timer()
      if not timer_closed then
        timer_closed = true
        timer_running = false
        if timer and not timer:is_closing() then
          timer:stop()
          timer:close()
        end
      end
    end

    timer:start(100, 100, vim.schedule_wrap(function()
      if timer_closed then
        return
      end

      attempts = attempts + 1

      local ok, tree_view = pcall(require, "nvim-tree.view")
      if ok then
        local is_visible = tree_view.is_visible()
        if debug_enabled then
          print("RESIZE: Attempt", attempts, "visible:", is_visible)
        end

        if is_visible then
          local tree_api_ok, tree_api = pcall(require, "nvim-tree.api")
          if tree_api_ok then
            local new_width = 40
            tree_api.tree.resize({ absolute = new_width })
            auto_resize_triggered = true
            if debug_enabled then
              print("RESIZE: DONE!")
            end

            -- Remove the autocmd callback since we're done
            if autocmd_id then
              vim.api.nvim_del_autocmd(autocmd_id)
              if debug_enabled then
                print("RESIZE: Autocmd removed")
              end
            end
          end
          cleanup_timer()
        elseif attempts >= max_attempts then
          if debug_enabled then
            print("RESIZE: Max attempts reached")
          end
          cleanup_timer()
        end
      else
        if attempts >= max_attempts then
          cleanup_timer()
        end
      end
    end))
  else
    if debug_enabled then
      print("RESIZE: Buffer doesn't qualify")
    end
  end
end

-- Create autocmd to trigger auto-resize on any buffer creation/opening
if debug_enabled then
  print("AUTO-RESIZE: Setting up autocmd")
end
autocmd_id = vim.api.nvim_create_autocmd({ "BufNew", "BufAdd", "BufEnter", "BufWinEnter" }, {
  callback = auto_resize_nvim_tree,
  desc = "Auto-resize nvim-tree on first real buffer in session"
})
