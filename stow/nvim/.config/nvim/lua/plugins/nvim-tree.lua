return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { { "hnvim-tree/nvim-web-devicons" } },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      api.config.mappings.default_on_attach(bufnr)

      -- your removals and mappings go here
      vim.keymap.del("n", "f", {
        buffer = bufnr,
      })
      -- remap the default keybindings
      vim.keymap.set("n", "\\", api.live_filter.start, opts("Live Filter: Start"))

      -- add custom key mapping to search in directory
      vim.keymap.set("n", "z", function()
        local node = api.tree.get_node_under_cursor()
        local grugFar = require("grug-far")
        if node then
          -- get directory of current file if it's a file
          local path
          if node.type == "directory" then
            -- Keep the full path for directories
            path = node.absolute_path
          else
            -- Get the directory of the file
            path = vim.fn.fnamemodify(node.absolute_path, ":h")
          end

          -- for macos replace all spaces in the path with "\ "
          if vim.fn.has("mac") == 1 then
            path = path:gsub(" ", "\\ ")
          end

          local prefills = {
            paths = path,
          }

          if not grugFar.has_instance("tree") then
            grugFar.open({
              instanceName = "tree",
              prefills = prefills,
              staticTitle = "Find and Replace from Tree",
              extraArgs = "--follow --hidden",
              folding = {
                enabled = true,
                foldlevel = 1,
                foldcolumn = "1",
              },
              openTargetWindow = {
                preferredLocation = "right",
              },
            })
          else
            grugFar.open_instance("tree")
            -- updating the prefills without clearing the search
            grugFar.update_instance_prefills("tree", prefills, false)
          end
        end
      end, opts("Search in directory"))
    end

    -- https://github.com/nvim-tree/nvim-tree.lua/blob/master/lua/nvim-tree.lua#L342
    nvimtree.setup({
      on_attach = my_on_attach,
      view = {
        width = 40,
        relativenumber = true,
      },
      sync_root_with_cwd = true,
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      tab = {
        sync = {
          open = true,
          close = true,
          ignore = {},
        },
      },
      -- pick window on open
      actions = {
        open_file = {
          resize_window = true,
          window_picker = {
            enable = true,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
      update_focused_file = {
        enable = true,
        update_root = {
          enable = false,
          ignore_list = {},
        },
        exclude = false,
      },
    })
  end,
}
