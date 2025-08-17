return {
  cmd = { "graphql-lsp", "server", "-m", "stream" },
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
  root_markers = { "graphql.config.*", ".graphqlrc.*", ".graphql.config.*", "schema.graphql" },
}