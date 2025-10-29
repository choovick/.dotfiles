-- Native Neovim LSP configuration for 0.11+
-- Based on https://gpanders.com/blog/whats-new-in-neovim-0-11/

-- Enable the LSP servers
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
  vim.lsp.enable(server)
end

-- LSP attach configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    -- Enable native completion if client supports it
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt_local.completeopt = { "menu", "menuone", "noinsert" }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

      -- Manual completion trigger
      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end, { buffer = bufnr, desc = "Trigger LSP completion" })
    end

    -- Custom keybindings with preferred tools
    local opts = { buffer = bufnr, silent = true }

    -- Override references to use FzfLua
    vim.keymap.set(
      "n",
      "gr",
      "<cmd>FzfLua lsp_references<CR>",
      vim.tbl_extend("force", opts, { desc = "Show LSP references" })
    )

    -- Override default mappings to use preferred tools
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

    vim.keymap.set(
      "n",
      "gi",
      "<cmd>FzfLua lsp_implementations<CR>",
      vim.tbl_extend("force", opts, { desc = "Show LSP implementations" })
    )

    vim.keymap.set(
      "n",
      "gt",
      "<cmd>FzfLua lsp_type_definitions<CR>",
      vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" })
    )

    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "See available code actions" })
    )

    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Smart rename" }))

    -- Diagnostic keybindings
    vim.keymap.set(
      "n",
      "<leader>D",
      "<cmd>Telescope diagnostics bufnr=0<CR>",
      vim.tbl_extend("force", opts, { desc = "Show buffer diagnostics" })
    )

    vim.keymap.set(
      "n",
      "<leader>d",
      vim.diagnostic.open_float,
      vim.tbl_extend("force", opts, { desc = "Show line diagnostics" })
    )

    vim.keymap.set("n", "<leader>xN", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))

    vim.keymap.set("n", "<leader>xn", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))

    -- LSP rstart keybinding
    vim.keymap.set("n", "<leader>r", function()
      -- Gitsigns detach/attach workaround
      vim.cmd("silent! Gitsigns detach")
      vim.cmd("silent! Gitsigns attach")

      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({ bufnr = buf })

      if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.WARN)
        return
      end

      local client_names = {}
      for _, lsp_client in ipairs(clients) do
        if lsp_client.name ~= "copilot" then
          table.insert(client_names, lsp_client.name)
          lsp_client.stop()
        end
      end

      vim.notify("Stopping LSP clients: " .. table.concat(client_names, ", "))

      vim.defer_fn(function()
        local filetype = vim.bo[buf].filetype
        if filetype and filetype ~= "" then
          vim.cmd("doautocmd FileType " .. filetype)

          vim.defer_fn(function()
            local new_clients = vim.lsp.get_clients({ bufnr = buf })
            if #new_clients > 0 then
              local new_names = {}
              for _, client in ipairs(new_clients) do
                table.insert(new_names, client.name)
              end
              vim.notify("LSP clients restarted: " .. table.concat(new_names, ", "))
            else
              vim.notify("No LSP clients restarted", vim.log.levels.WARN)
            end
          end, 1000)
        end
      end, 500)
    end, vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
  end,
})

-- Configure diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = "󰋼 ",
    },
  },
  virtual_lines = {
    current_line = true,
  },
})
