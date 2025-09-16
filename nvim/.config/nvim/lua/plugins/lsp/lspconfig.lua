return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "saghen/blink.cmp" },
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

    -- Configure diagnostics with modern API
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅙 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = "󰋼 ",
        },
        -- currently signs are below on priority list
        -- priority = 5
      },
      virtual_lines = {
        -- Only show virtual line diagnostics for the current cursor line
        current_line = true,
      },
    })

    -- Get blink.cmp capabilities
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Enable LSP servers with blink.cmp capabilities
    local servers = {
      "lua_ls",
      "pyright",
      "terraformls",
      "graphql",
      "bashls",
      "yamlls",
      "helm_ls",
      "kcl",
    }

    for _, server in ipairs(servers) do
      vim.lsp.enable(server, {
        capabilities = capabilities,
      })
    end
  end,
}
