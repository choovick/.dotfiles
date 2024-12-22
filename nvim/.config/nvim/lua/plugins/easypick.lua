return {
  "axkirillov/easypick.nvim",
  requires = "nvim-telescope/telescope.nvim",

  config = function()
    local easypick = require("easypick")

    -- add a new picker
    easypick.setup({
      pickers = {
        -- diff current branch with base_branch and show files that changed with respective diffs in preview
        {
          name = "Changed_files",
          command = "git ls-files --others --exclude-standard --modified",
          previewer = easypick.previewers.file_diff(),
        },
      },
    })

    vim.keymap.set({ "n" }, "<leader>fg", "<cmd>Easypick Changed_files<CR>", { desc = "Pick changed files" })
  end,
}
