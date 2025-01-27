return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Add current file to Harpoon list" })

    vim.keymap.set("n", "<leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Toggle Harpoon list" })

    vim.keymap.set("n", "<leader>h1", function()
      harpoon:list():select(1)
    end, { desc = "Select Harpoon list item 1" })
    vim.keymap.set("n", "<leader>h2", function()
      harpoon:list():select(2)
    end, { desc = "Select Harpoon list item 2" })
    vim.keymap.set("n", "<leader>h3", function()
      harpoon:list():select(3)
    end, { desc = "Select Harpoon list item 3" })
    vim.keymap.set("n", "<leader>h4", function()
      harpoon:list():select(4)
    end, { desc = "Select Harpoon list item 4" })
    vim.keymap.set("n", "<leader>h5", function()
      harpoon:list():select(5)
    end, { desc = "Select Harpoon list item 5" })
    vim.keymap.set("n", "<leader>h6", function()
      harpoon:list():select(6)
    end, { desc = "Select Harpoon list item 6" })
    vim.keymap.set("n", "<leader>h7", function()
      harpoon:list():select(7)
    end, { desc = "Select Harpoon list item 7" })
    vim.keymap.set("n", "<leader>h8", function()
      harpoon:list():select(8)
    end, { desc = "Select Harpoon list item 8" })
    vim.keymap.set("n", "<leader>h9", function()
      harpoon:list():select(9)
    end, { desc = "Select Harpoon list item 9" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end)
  end,
}
