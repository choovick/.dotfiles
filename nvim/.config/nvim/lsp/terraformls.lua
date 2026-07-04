return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  -- Avoid using .git: it roots at the monorepo and indexes ~50k .tf files.
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
      return
    end
    on_dir(vim.fs.root(path, { ".terraform" }) or vim.fs.dirname(path))
  end,
  init_options = {
    ignoreSingleFileWarning = true,
    indexing = {
      ignorePaths = {
        "terraform/project-templates",
        "project-templates",
      },
      ignoreDirectoryNames = {
        "project-templates",
        ".terragrunt-cache",
      },
    },
    experimentalFeatures = {
      validateOnSave = false,
    },
    validation = {
      enableEnhancedValidation = false,
    },
  },
  on_attach = function(client, bufnr)
    -- hashicorp/terraform-ls#2094: invalid semantic tokens hang Neovim 0.12
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
