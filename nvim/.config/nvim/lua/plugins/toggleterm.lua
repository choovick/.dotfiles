return {
  {
    "akinsho/toggleterm.nvim",
    -- disable in the preference of tmux panes
    enabled = false,
    version = "*",
    -- enabled = false,
    -- opts = {
    -- 	--[[ things you want to change go here]]
    -- 	open_mapping = [[<C-t>]],
    -- 	shade_terminals = false,
    -- },
    config = function()
      require("toggleterm").setup({
        --[[ things you want to change go here]]
        open_mapping = [[<C-t>]],
        shade_terminals = false,
      })

      -- Toggle terminal
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        -- vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
      -- toggleterm in the directory of the current buffer
      vim.keymap.set("n", "<leader>tt", function()
        -- check if we are in the buffer of a file
        if vim.bo.buftype == "nofile" then
          vim.notify("No file in current buffer", "error", { title = "ToggleTerm" })
          return
        end
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("ToggleTerm dir='" .. dir .. "'")
      end, { desc = "Toggle terminal in current buffer directory" })
    end,
  },
}
