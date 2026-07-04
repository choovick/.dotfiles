return {
  "qvalentin/helm-ls.nvim",
  enabled = false, -- superseded by native helm_ls LSP config in lsp/helm_ls.lua
  ft = "helm",
  opts = {
    conceal_templates = {
      -- enable the replacement of templates with virtual text of their current values
      enabled = false, -- this might change to false in the future
    },
  },
}
