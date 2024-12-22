return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local options = {
      -- https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua
      engines = {
        ripgrep = {
          -- extra args that you always want to pass to rg
          -- like for example if you always want context lines around matches
          extraArgs = "--follow ",
        },
      },

      -- folding related options
      folding = {
        -- whether to enable folding
        enabled = true,

        -- sets foldlevel, folds with higher level will be closed.
        -- result matche lines for each file have fold level 1
        -- set it to 0 if you would like to have the results initially collapsed
        -- See :h foldlevel
        foldlevel = 1,

        -- visual indicator of folds, see :h foldcolumn
        -- set to '0' to disable
        foldcolumn = "1",
      },
    }

    -- common setup
    require("grug-far").setup(options)
  end,
}
