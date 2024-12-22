local wezterm = require("wezterm")
local config = {}

-- font
config.font = wezterm.font("Hack Nerd Font Propo", {})
config.font_size = 16

config.max_fps = 120

-- do not resize font size when window is resized
config.adjust_window_size_when_changing_font_size = false

-- dynamic color scheme switching
local function mode_overrides(appearance)
  if appearance:find("Dark") then
    return {
      color_scheme = "Gruvbox Material (Gogh)",
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
--/ dynamic color scheme switching
config.window_decorations = "RESIZE" -- "TITLE | RESIZE"
config.enable_tab_bar = false
config.use_fancy_tab_bar = false

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- when inactive, make the background opaque
wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
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

return config
