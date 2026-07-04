return {
  "numToStr/Comment.nvim",
  config = function()
    local ft = require("Comment.ft")
    -- adding kcl
    ft.set("kcl", { "# %s", '"""%s\n"""' })
    -- .zshrc-func and other zsh buffers use filetype=zsh, which Comment.nvim
    -- does not ship by default (only bash/sh).
    ft.set("zsh", ft.get("bash"))

  end,
}
