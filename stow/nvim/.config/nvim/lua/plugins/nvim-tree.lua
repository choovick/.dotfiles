return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      local lib = require("nvim-tree.lib")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      -- your removals and mappings go here
      vim.keymap.del("n", "f", { buffer = bufnr })
      -- remap the default keybindings
      vim.keymap.set("n", "\\", api.live_filter.start, opts("Live Filter: Start"))

      -- add custom key mapping to search in directory
      vim.keymap.set("n", "z", function()
        local node = lib.get_node_at_cursor()
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

          if not grugFar.has_instance("far") then
            grugFar.grug_far({
              instanceName = "far",
              prefills = prefills,
              staticTitle = "Find and Replace from Tree",
            })
          else
            grugFar.open_instance("far")
            -- updating the prefills without clearing the search
            grugFar.update_instance_prefills("far", prefills, false)
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
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          resize_window = true,
          window_picker = {
            enable = false,
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
