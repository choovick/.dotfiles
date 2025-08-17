return {
  cmd = { "helm_ls", "serve" },
  filetypes = { "helm" },
  root_markers = { "Chart.yaml", "values.yaml" },
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
        config = {
          schemas = {
            kubernetes = "**/templates/**.yaml",
          },
          completion = true,
          hover = true,
        },
      },
    },
  },
}