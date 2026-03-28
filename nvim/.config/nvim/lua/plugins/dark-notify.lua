return {
  "cormacrelf/dark-notify",
  config = function()
    local dn = require("dark_notify")

    dn.configure({
      schemes = {
        dark = "gruvbox",
        light = "gruvbox",
      },
    })

    dn.update()
    dn.run()
  end,
}
