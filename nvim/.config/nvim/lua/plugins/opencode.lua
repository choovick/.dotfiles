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
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- https://github.com/NickvanDyke/opencode.nvim/blob/main/lua/opencode/config.lua
      server = {
        port = 4096,
        start = function() end,
        stop = function() end,
        toggle = function() end,
      },
    }

    vim.o.autoread = true

    -- stylua: ignore start
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>op", function() require("opencode").select() end,                          { desc = "Select action" })
    vim.keymap.set("n",          "<leader>on", function() require("opencode").command("session.new") end,             { desc = "New session" })
    vim.keymap.set("n",          "<leader>os", function() require("opencode").command("session.select") end,          { desc = "Select session" })
    vim.keymap.set("n",          "<leader>oS", function() require("opencode").command("session.share") end,           { desc = "Share session" })
    vim.keymap.set("n",          "<leader>oc", function() require("opencode").command("session.compact") end,         { desc = "Compact session" })
    vim.keymap.set("n",          "<leader>oi", function() require("opencode").command("session.interrupt") end,       { desc = "Interrupt session" })
    vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end,                           { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("x", "<leader>oy", function() copy_code_reference(false) end, { desc = "Copy code reference" })
    vim.keymap.set("x", "<leader>oY", function() copy_code_reference(true) end,  { desc = "Copy code reference with content" })

    vim.keymap.set({ "n", "i", "t" }, "<M-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll messages up" })
    vim.keymap.set({ "n", "i", "t" }, "<M-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll messages down" })
    -- stylua: ignore end
  end,
}
