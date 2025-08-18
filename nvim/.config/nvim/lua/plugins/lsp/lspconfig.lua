return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local keymap = vim.keymap

    -- Global LSP attach function for keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- LSP keybindings
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)
        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        opts.desc = "Go to definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)
        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", opts)
        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        opts.desc = "Smart rename"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)
        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>r", function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local restarted = {}
          for _, client in pairs(clients) do
            if client.name ~= "copilot" then
              table.insert(restarted, client.name)
              vim.lsp.stop_client(client.id, true)
            end
          end
          if #restarted > 0 then
            vim.notify("Restarting LSP servers: " .. table.concat(restarted, ", "))
          else
            vim.notify("No LSP servers to restart")
          end
          vim.defer_fn(function()
            vim.cmd("edit")
          end, 100)
        end, opts)
      end,
    })

    -- Diagnostic symbols
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Enable LSP servers using the new vim.lsp.enable() function
    -- These will automatically use configurations from the lsp/ directory
    vim.lsp.enable({
      "lua_ls",
      "pyright",
      "terraformls",
      "graphql",
      "bashls",
      "yamlls",
      "helm_ls",
      "kcl",
    })
  end,
}
