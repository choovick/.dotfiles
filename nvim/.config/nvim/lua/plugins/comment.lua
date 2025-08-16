return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()

    local ft = require("Comment.ft")
    -- adding kcl
    ft.set("kcl", { "# %s", '"""%s\n"""' })
  end,
}
