-- Custom @helm.* capture groups live in queries/helm/highlights.scm.
-- Gruvbox does not define those groups, so without links template syntax
-- collapses into one flat color. Treesitter for helm is started in
-- lua/plugins/treesitter.lua (FileType autocmd) — not here.

local function set_helm_highlights()
  local hl = vim.api.nvim_set_hl
  hl(0, "@helm.define", { link = "Special", default = true }) -- define "chart.helper"
  hl(0, "@helm.keyword", { link = "Keyword", default = true }) -- if / else / range / with
  hl(0, "@helm.delimiter", { link = "NonText", default = true }) -- {{ }} / {{- -}}
  hl(0, "@helm.root", { link = "Type", default = true }) -- .Values, .Chart, .Release, ...
end

set_helm_highlights()

-- dark-notify reloads gruvbox on macOS appearance changes; re-apply links.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("HelmHighlights", { clear = true }),
  callback = set_helm_highlights,
})
