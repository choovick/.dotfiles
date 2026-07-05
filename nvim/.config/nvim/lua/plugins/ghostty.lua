-- Requires: brew install tree-sitter-cli  (for `make nvim_install`)
return {
  "bezhermoso/tree-sitter-ghostty",
  build = "make nvim_install",
}
