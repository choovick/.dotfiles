-- set leader key to space
vim.g.mapleader = " "

-- set keymaps
local keymap = vim.keymap -- for conciseness

-- to prevent paste over visual selection to copy to clipboard
vim.api.nvim_set_keymap("v", "p", '"_dP', { noremap = true, silent = true })

-- use jk to exit insert mode
keymap.set({ "i", "v" }, "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- save file command
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- bind fd to quit one
keymap.set("n", "fd", "<cmd>q<cr>", { desc = "Quit" })
-- bind fg to delete buffer
keymap.set("n", "fg", "<cmd>bp <bar> bd #<CR>", { desc = "Close buffer" })

-- Lazy hotkey
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Mason
keymap.set("n", "<leader>M", "<cmd>Mason<cr>", { desc = "Mason" })

-- Trim
keymap.set("n", "<leader>ct", "<cmd>Trim<cr>", { desc = "Trim Whitespaces" })

-- increment/decrement number
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- WINDOW MANAGEMENT
keymap.set("n", "<leader>sv", "<C-w>s", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>v", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
-- close buffer without removing split, leave last buffer
keymap.set("n", "<leader>sX", "<cmd>bp <bar> bd #<CR>", { desc = "Close buffer" })

keymap.set("n", "<leader>ss", "<C-x>", { desc = "Swap current window with next" }) -- swap window with next

keymap.set("n", "<leader>tN", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- QUICKFIX
keymap.set("n", "<leader>qq", "<cmd>copen<CR>", { desc = "Open quickfix" }) -- open quickfix
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix" }) -- close quickfix
keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Go to next quickfix" }) -- go to next quickfix
keymap.set("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "Go to previous quickfix" }) -- go to previous quickfix

-- NAVIGATION/FINDING
-- keymap.set("n", "<leader>ff", "<cmd>Telescope find_files follow=true<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader> ", function()
  require("fzf-lua").files({ resume = true })
end, { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>ff", function()
  -- require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h"), follow = true })
  require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h"), resume = true })
end, { desc = "Fuzzy find files in current butter dir" })

keymap.set("n", "<leader>fr", function()
  require("fzf-lua").oldfiles({ cwd_only = true, include_current_session = false, resume = true })
end, { desc = "Old files in current dir" })
keymap.set("n", "<leader>fR", function()
  require("fzf-lua").oldfiles({ resume = true })
end, { desc = "Fuzzy find recent files across sessions" })

keymap.set(
  "n",
  "<leader>fs",
  "<cmd>FzfLua live_grep_glob resume=true<cr>",
  { desc = "Live grep with rg --glob support" }
)
keymap.set("n", "<leader>fd", function()
  require("fzf-lua").live_grep_glob({ cwd = vim.fn.expand("%:p:h"), resume = true })
end, { desc = "Live grep in current buffer directory" })
keymap.set("n", "<leader>fc", "<cmd>FzfLua grep_cword<cr>", { desc = "Find string under cursor in cwd" })
keymap.set("n", "<leader>fl", "<cmd>FzfLua lgrep_curbuf resume=true<cr>", { desc = "Live grep in current buffer" })

keymap.set("n", "<leader>fa", function()
  require("grug-far").toggle_instance({ instanceName = "far", staticTitle = "Find and Replace" })
end, { desc = "Open GrugFar for find and replace" })

keymap.set("v", "<leader>fA", function()
  -- get content of visual selection
  local selection = vim.fn.getreg("v")

  require("grug-far").grug_far({
    prefills = {
      search = selection,
      replacement = "",
      filesFilter = "",
      flags = "",
      paths = vim.fn.expand("%:p:h"),
    },
    { transient = true },
  })
end, { desc = "Open GrugFar for find and replace selection in current buffer dir" })

keymap.set("v", "<leader>fa", function()
  -- get content of visual selection
  local selection = vim.fn.getreg("v")

  require("grug-far").grug_far({
    prefills = {
      search = selection,
      replacement = "",
      filesFilter = "",
      flags = "",
      paths = "",
    },
    { transient = true },
  })
end, { desc = "Open GrugFar for find and replace" })

keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Select Buffer" })
keymap.set("n", "<leader>fl", "<cmd>FzfLua blines<cr>", { desc = "Search in current Buffer" })

-- EXPLORER
-- Define a global function to change directory to git root
-- _G.change_to_git_root = function()
vim.api.nvim_create_user_command("CwdGitRoot", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and git_root ~= "" then
    vim.cmd("cd " .. git_root)
    print("Changed directory to " .. git_root)
  else
    print("Not in a git repository")
  end
end, { desc = "Change directory to git root" })

-- Keymap to trigger the function
vim.api.nvim_set_keymap(
  "n",
  "<leader>eR",
  ":CwdGitRoot<CR>",
  { noremap = true, silent = true, desc = "Change directory to git root" }
)

-- Define a custom function to change the current working directory to the directory of the current buffer
vim.api.nvim_create_user_command("CwdCurrentBuffer", function()
  local buffer_name = vim.api.nvim_buf_get_name(0)
  if buffer_name == "" then
    print("No file in the current buffer")
    return
  end
  local buffer_dir = vim.fn.fnamemodify(buffer_name, ":p:h")
  vim.cmd("cd " .. buffer_dir)
  print("Changed directory to " .. buffer_dir)
end, { desc = "Change directory to current buffer" })

-- Keymap to call the global function (you can customize <leader>cd to your preferred key combination)
vim.api.nvim_set_keymap(
  "n",
  "<leader>eB",
  ":CwdCurrentBuffer<CR>",
  { noremap = true, silent = true, desc = "Change directory to current buffer" }
)

-- neotree
keymap.set("n", "<leader>ee", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" }) -- toggle file explorer
keymap.set("n", "fe", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "File explorer on current file" }) -- toggle file explorer on current file
keymap.set("n", "<leader>ec", "<cmd>NvimTreeClose<CR>", { desc = "Close file explorer" }) -- collapse file explorer
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

-- ACTIONS
-- clear search highlights
keymap.set("n", "<leader>ah", ":nohl<CR>", { desc = "Clear search highlights" })

-- to convert yaml to json using: yq -p yaml -o json
keymap.set(
  { "v", "n" },
  "<leader>aj",
  ":%!yq -p yaml -o json<CR>",
  { noremap = true, silent = true, desc = "Convert yaml to json" }
)
-- to convert json to yaml using: yq -p json -o yaml
keymap.set(
  { "v", "n" },
  "<leader>ay",
  ":%!yq -p json -o yaml<CR>",
  { noremap = true, silent = true, desc = "Convert json to yaml (Unminify JSON)" }
)
-- unescape json string using jq
keymap.set(
  { "v", "n" },
  "<leader>aE",
  ":%!jq -r .<CR>",
  { noremap = true, silent = true, desc = "Unescape JSON string" }
)
-- escape stining to json string using jq
keymap.set(
  { "v", "n" },
  "<leader>ae",
  ":%!jq -Rsa .<CR>",
  { noremap = true, silent = true, desc = "Escape string to JSON string" }
)

-- json minify using jq
keymap.set({ "v", "n" }, "<leader>am", ":%!jq -c .<CR>", { noremap = true, silent = true, desc = "Minify JSON" })

-- base64 encode using <leader>ab
keymap.set({ "v", "n" }, "<leader>ab", ":%!base64<CR>", { noremap = true, silent = true, desc = "Base64 encode" })

-- base64 decode using <leader>aB
keymap.set({ "v", "n" }, "<leader>aB", ":%!base64 -d<CR>", { noremap = true, silent = true, desc = "Base64 decode" })

-- use openssl to decode certifcate using: openssl x509 -in /dev/stdin -text -noout
keymap.set(
  { "v", "n" },
  "<leader>ac",
  ":%!openssl x509 -in /dev/stdin -text -noout<CR>",
  { noremap = true, silent = true, desc = "Decode certificate" }
)

-- telescope diff
vim.keymap.set("n", "<leader>aD", function()
  require("telescope").extensions.diff.diff_files({ hidden = true })
end, { desc = "Compare 2 files" })
vim.keymap.set("n", "<leader>ad", function()
  require("telescope").extensions.diff.diff_current({ hidden = true })
end, { desc = "Compare file with current" })

-- action to select all text leader aa
keymap.set({ "v", "n" }, "<leader>aa", "ggVG", { noremap = true, silent = true, desc = "Select all text" })

-- DIFFING HELPERS
vim.api.nvim_create_user_command("DiffClip", function()
  vim.cmd([[
    let ft=&ft
    leftabove vnew [Clipboard]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put +
    0d_
    " remove CR for Windows
    silent %s/\r$//e
    execute "set ft=" . ft
    diffthis
    wincmd p
    diffthis
  ]])
end, { desc = "Compare Active File with Clipboard" })

-- add <leader>aD to compare active file with clipboard
keymap.set("n", "<leader>aD", ":DiffClip<CR>", { desc = "Compare Active File with Clipboard" })

vim.api.nvim_create_user_command("DiffLastTwo", function()
  local bufnr1 = vim.fn.bufnr("#")
  local bufnr2 = vim.fn.bufnr("%")

  if bufnr1 == -1 or bufnr2 == -1 then
    print("No previous buffer found")
    return
  end

  vim.cmd("tabnew") -- Open a new tab
  vim.cmd("b " .. bufnr1) -- Switch to the previous buffer
  vim.cmd("diffthis") -- Start diff mode for the previous buffer
  vim.cmd("vsplit") -- Open a vertical split
  vim.cmd("b " .. bufnr2) -- Switch to the current buffer
  vim.cmd("diffthis") -- Start diff mode for the current buffer
end, { desc = "Compare Last Two Buffers" })

-- add <leader>ad to compare last two buffers
keymap.set("n", "<leader>ad", ":DiffLastTwo<CR>", { desc = "Compare Last Two Buffers" })

-- add action to toggle word wrap
keymap.set("n", "<leader>aw", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })

-- override q: wiht FzfLua command_history
keymap.set({ "n", "v" }, "q:", "<cmd>FzfLua command_history<cr>", { desc = "Command history" })
-- leader : to open FzfLua commands
keymap.set({ "n", "v" }, "<leader>:", "<cmd>FzfLua commands<cr>", { desc = "FzfLua commands" })

-- Create a new tmux pane with the current file's directory or current working directory
vim.api.nvim_create_user_command("TmuxNewPaneDir", function(arg)
  local argStr = arg.args
  if not (argStr == "vc" or argStr == "hc" or argStr == "vb" or argStr == "hb") then
    print(
      "Invalid argument. Acceptable values are 'vc', 'hc', 'vb', 'hb'. 'v' or 'h' for vertical or horizontal split, 'c' or 'b' for current working directory or buffer directory."
    )
    return
  end
  local dir
  local splitType = argStr:sub(1, 1) == "v" and "-v" or "-h" -- determine split type based on first letter
  if argStr:sub(2, 2) == "c" then
    dir = vim.fn.getcwd()
  else
    dir = vim.fn.expand("%:p:h")
  end
  if dir == "" then
    print("Directory is empty")
    return
  end
  -- Construct the tmux command
  local tmuxCommand = string.format("tmux split-window %s -c %s", splitType, dir)
  -- Execute the tmux command
  os.execute(tmuxCommand)
  print("Created new tmux pane in directory " .. dir)
end, { nargs = 1, desc = "Create a new tmux pane with the current file's directory or current working directory" })

-- sV to create a new tmux pane vertically with the current buffer directory or current working directory
keymap.set({ "n", "v" }, "<leader>sV", ":TmuxNewPaneDir vb<CR>", {
  noremap = true,
  silent = true,
  desc = "Create a new tmux pane vertically with the current buffer directory or current working directory",
})

-- sH to create a new tmux pane horizontally with the current buffer directory or current working directory
keymap.set({ "n", "v" }, "<leader>sH", ":TmuxNewPaneDir hb<CR>", {
  noremap = true,
  silent = true,
  desc = "Create a new tmux pane horizontally with the current buffer directory or current working directory",
})

-- alt-i,o to BufferNext and alt-i to BufferPrevious in all modes
keymap.set({ "n", "v", "i", "x" }, "<A-o>", "<cmd>BufferNext<CR>", { desc = "Next buffer" })
keymap.set({ "n", "v", "i", "x" }, "<A-i>", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
