local wezterm = require("wezterm")
local config = {}

-- font
config.font = wezterm.font("Hack Nerd Font Propo", {})
config.font_size = 16

config.max_fps = 120

-- do not resize font size when window is resized
config.adjust_window_size_when_changing_font_size = false

config.hyperlink_rules = {
  -- Matches: a URL in parens: (URL)
  {
    regex = '\\((\\w+://\\S+)\\)',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = '\\[(\\w+://\\S+)\\]',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = '\\{(\\w+://\\S+)\\}',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = '<(\\w+://\\S+)>',
    format = '$1',
    highlight = 1,
  },
  -- Then handle URLs not wrapped in brackets
  -- HACK: removed trailing brackets from regex
  {
    regex = '\\b\\w+://\\S+[/a-zA-Z0-9-]+',
    format = '$0',
  },
  -- implicit mailto link
  {
    regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
    format = 'mailto:$0',
  },
}

-- dynamic color scheme switching
local function mode_overrides(appearance)
  if appearance:find("Dark") then
    return {
      color_scheme = "Gruvbox Dark (Gogh)",
      -- background = "#1e1e1e",
    }
  else
    return {
      color_scheme = "catppuccin-latte",
      -- background = "#d1d1d1",
    }
  end
end
wezterm.on("window-config-reloaded", function(window, _)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local overrides_appearance = mode_overrides(appearance)
  local scheme = overrides_appearance.color_scheme
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    -- overrides.colors = {
    -- 	background = overrides_appearance.background,
    -- }
    window:set_config_overrides(overrides)
  end
end)
-- / dynamic color scheme switching
-- config.window_decorations = "RESIZE" -- "TITLE | RESIZE"
config.enable_tab_bar = false
config.use_fancy_tab_bar = false

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- when inactive, make the background opaque
wezterm.on("update-status", function(window, pane)
  local appearance = window:get_appearance()
  local overrides_appearance = mode_overrides(appearance)
  if window:is_focused() then
    overrides_appearance.window_background_opacity = 0.90
  else
    overrides_appearance.window_background_opacity = 1
  end
  window:set_config_overrides(overrides_appearance)
end)

-- config.colors = {}

-- background blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 10

-- dont confirm on exit
config.window_close_confirmation = "NeverPrompt"

config.keys = { -- remap ctrl tab to option tab
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.SendKey({
      key = "Tab",
      mods = "OPT",
    }),
  },
  -- remap ctrl shift tab to option shift tab
  {
    key = "Tab",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendKey({
      key = "~",
      mods = "OPT",
    }),
  },
  -- Map Cmd+S to send <ESC>:w<CR>
  {
    key = "s",
    mods = "CMD",
    action = wezterm.action.SendString("\x1b:w\n"),
  },
}

return config
