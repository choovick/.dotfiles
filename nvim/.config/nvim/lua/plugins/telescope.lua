return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "folke/trouble.nvim",
  },
  -- so require("telescope") is available
  module = "telescope",
  cmd = "Telescope",
  event = "VimEnter",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          -- all required except `--smart-case`
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          -- add your options
          "--follow",
          "--hidden",
        },

        -- path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- send all to quickfix list
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfix list
            ["<C-t>"] = open_with_trouble, -- open in trouble
          },
        },
        pickers = {
          find_files = {
            -- follow symlinks
            follow = true,
            hidden = true,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    -- keymaps are set in keymaps.lua
    -- local keymap = vim.keymap -- for conciseness
    --
    -- keymap.set("n", "<leader>ff", "<cmd>Telescope find_files follow=true<cr>", { desc = "Fuzzy find files in cwd" })
    -- keymap.set("n", "<leader> ", "<cmd>Telescope find_files follow=true<cr>", { desc = "Fuzzy find files in cwd" })
    -- keymap.set("n", "<leader>fb", function()
    -- 	require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h"), follow = true })
    -- end, { desc = "Fuzzy find files in current butter dir" })
    -- keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles follow=true<cr>", { desc = "Fuzzy find recent files" })
    -- keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    -- keymap.set("n", "<leader>fS", "<cmd>Spectre<cr>", { desc = "Open Spectre for find and replace" })
    -- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    -- keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
