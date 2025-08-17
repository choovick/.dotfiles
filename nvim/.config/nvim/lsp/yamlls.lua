return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = "**/templates/**.yaml",
      },
      completion = true,
      hover = true,
    },
  },
}