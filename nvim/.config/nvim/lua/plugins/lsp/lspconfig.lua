 return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} }, -- Configures LuaLS for Neovim development
    { "towolf/vim-helm" },
    "williamboman/mason.nvim", -- Mason itself, a dependency for mason-lspconfig
    "williamboman/mason-lspconfig.nvim", -- Bridges mason and lspconfig
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    -- Common on_attach function for LSP servers
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }

      -- Keybindings (from your original config)
      opts.desc = "Show LSP references"
      keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)
      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      opts.desc = "Go to definition"
      keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)
      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", opts) -- Changed FzfLua command slightly if it was a typo for types
      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      opts.desc = "Smart rename"
      keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)
      opts.desc = "Show buffer diagnostics (Telescope)"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>r", ":LspRestart<CR>", opts) -- Ensure LspRestart is a valid command (often provided by lspconfig or another plugin)

      -- If nvim-lsp-file-operations is correctly set up, its functionalities
      -- like rename, code_action might be enhanced or automatically handled.
      -- You might not need a manual :LspRestart if using a robust setup.
    end

    -- Autocmd to call on_attach function when LSP attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }), -- Added clear = true
      callback = function(ev)
        -- Attach the common on_attach function
        on_attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
      end,
    })

    -- LSP Capabilities (from cmp-nvim-lsp)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Diagnostic Symbols
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configure mason-lspconfig to automatically set up servers installed with Mason
    mason_lspconfig.setup({
      -- A list of servers to automatically install if they're not already installed.
      -- This is optional. You can manage installations manually via Mason UI.
      ensure_installed = {
        "pyright",
        "terraformls",
        "graphql",
        "lua_ls",
        "bashls",
        -- "svelte",
        -- "emmet_ls",
        "yamlls", -- For helm_ls dependency
      },
      automatic_installation = true, -- You can also set this to true if you want ensure_installed to automatically install
    })

    -- Specific server configurations using lspconfig
    -- These will be automatically picked up by mason-lspconfig if the server is installed

    -- Pyright (Python)
    lspconfig["pyright"].setup({
      capabilities = capabilities,
      -- on_attach = on_attach, -- Already handled by the global LspAttach autocmd
      -- Pyright specific settings can go into a settings = { python = { ... } } table if needed
    })

    -- TerraformLS
    lspconfig["terraformls"].setup({
      capabilities = capabilities,
      filetypes = { "terraform", "terraform-vars", "tf", "tfvars" },
    })

    -- GraphQL
    lspconfig["graphql"].setup({
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- LuaLS (for Neovim Lua development, enhanced by neodev.nvim)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT", -- Or "Lua 5.1" depending on your Neovim version
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false, -- Avoid diagnostics from runtime path libraries if desired
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    -- BashLS
    lspconfig["bashls"].setup({
      capabilities = capabilities,
    })

    -- Svelte (example if you uncomment)
    -- lspconfig["svelte"].setup({
    --   capabilities = capabilities,
    --   on_attach = function(client, bufnr)
    --     on_attach(client, bufnr) -- Call the common on_attach
    --     vim.api.nvim_create_autocmd("BufWritePost", {
    --       group = vim.api.nvim_create_augroup("SvelteTsJsWatch", { clear = true }),
    --       pattern = { "*.js", "*.ts" },
    --       callback = function(ctx)
    --         if client.name == 'svelte' then
    --           client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_bufnr(ctx.buf) })
    --         end
    --       end,
    --     })
    --   end,
    -- })

    -- Emmet LS (example if you uncomment)
    -- lspconfig["emmet_ls"].setup({
    --   capabilities = capabilities,
    --   filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    -- })

    -- KCL (managed outside Mason, as per your original config)
    lspconfig.kcl.setup({
      capabilities = capabilities, -- It's good practice to pass capabilities
    })

    -- Helm LS
    lspconfig.helm_ls.setup({
      capabilities = capabilities,
      settings = {
        ["helm-ls"] = {
          yamlls = {
            path = "yaml-language-server", -- Ensure yamlls is installed (e.g., via mason)
            config = {
              schemas = {
                kubernetes = "**/templates/**.yaml", -- Adjusted pattern slightly
              },
              completion = true,
              hover = true,
            },
          },
        },
      },
    })

    -- If you have other language servers, configure them similarly
  end,
}
