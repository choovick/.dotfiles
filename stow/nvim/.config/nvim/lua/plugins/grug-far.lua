return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local options = {
      -- https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua
      engines = {
        ripgrep = {
          -- extra args that you always want to pass to rg
          -- like for example if you always want context lines around matches
          extraArgs = "--follow --hidden",
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
      openTargetWindow = {
        -- filter for windows to exclude when considering candidate targets. It's a list of either:
        -- * filetype to exclude
        -- * filter function of the form: function(winid: number): boolean (return true to exclude)
        -- exclude = {'nvimtree'},

        -- preferred location for target window relative to the grug-far window. If an existing candidate
        -- window that is not excluded by the exclude filter exists in that direction, it will be reused,
        -- otherwise a new window will be created in that direction.
        -- available options: "prev" | "left" | "right" | "above" | "below"
        preferredLocation = "right",
      },
    }

    -- common setup
    require("grug-far").setup(options)
  end,
}
