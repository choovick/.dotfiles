-- Browser markdown preview (KaTeX, Mermaid, Graphviz, sync scroll).
-- Requires the Vivify CLI on $PATH: brew install jannis-baum/tap/vivify
-- Server starts lazily per viewer tab and exits when the last tab closes.
return {
  "jannis-baum/vivify.vim",
  cmd = "Vivify",
  keys = {
    { "<leader>cG", "<cmd>Vivify<cr>", desc = "Vivify markdown preview" },
  },
}
