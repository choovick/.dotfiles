return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "towolf/vim-helm" },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- opts.desc = "Show LSP definitions"
        -- keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>FzfLua lsp_definitions<CR>", opts)

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
        keymap.set("n", "<leader>r", ":LspRestart<CR>", opts)
      end,
    })

    -- enable language server for bash https://github.com/bash-lsp/bash-language-server?tab=readme-ov-file#neovim
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sh",
      callback = function()
        vim.lsp.start({
          name = "bash-language-server",
          cmd = { "bash-language-server", "start" },
        })
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- KCL, Install language server from Brew, dont use mason: https://github.com/kcl-lang/kcl.nvim/issues/18
    lspconfig.kcl.setup({})

    -- helm https://github.com/mrjosh/helm-ls?tab=readme-ov-file#nvim-lspconfig-setup
    lspconfig.helm_ls.setup({
      settings = {
        ["helm-ls"] = {
          yamlls = {
            path = "yaml-language-server",
            config = {
              schemas = {
                kubernetes = "**/templates/**",
              },
              completion = true,
              hover = true,
              -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
            },
          },
        },
      },
    })

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      -- ["svelte"] = function()
      --   -- configure svelte server
      --   lspconfig["svelte"].setup({
      --     capabilities = capabilities,
      --     on_attach = function(client, bufnr)
      --       vim.api.nvim_create_autocmd("BufWritePost", {
      --         pattern = { "*.js", "*.ts" },
      --         callback = function(ctx)
      --           -- Here use ctx.match instead of ctx.file
      --           client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      --         end,
      --       })
      --     end,
      --   })
      -- end,
      ["terraformls"] = function()
        -- configure terraform server
        lspconfig["terraformls"].setup({
          capabilities = capabilities,
          filetypes = { "terraform", "terraform-vars", "tf", "tfvars" },
        })
      end,

      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      -- ["emmet_ls"] = function()
      --   -- configure emmet language server
      --   lspconfig["emmet_ls"].setup({
      --     capabilities = capabilities,
      --     filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      --   })
      -- end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })

        -- add handler for bash laguage server
        lspconfig["bashls"].setup({
          capabilities = capabilities,
        })
      end,
    })
  end,
}
