local wezterm = require("wezterm")
local act = wezterm.action

local function generate_keys(key_name)
   return {
      key = key_name,
      mods = "WIN",
      action = act.SendKey({
         key = key_name,
         mods = "ALT",
      }),
   }
end

return {
   {
      key = [[\]],
      mods = "CTRL|ALT",
      action = wezterm.action({
         SplitHorizontal = { domain = "CurrentPaneDomain" },
      }),
   },
   {
      key = [[\]],
      mods = "CTRL",
      action = wezterm.action({
         SplitVertical = { domain = "CurrentPaneDomain" },
      }),
   },
   {
      key = "q",
      mods = "CTRL",
      action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
   },
   {
      key = "h",
      mods = "CTRL|ALT",
      action = wezterm.action({ ActivatePaneDirection = "Left" }),
   },
   {
      key = "l",
      mods = "CTRL|ALT",
      action = wezterm.action({ ActivatePaneDirection = "Right" }),
   },
   {
      key = "k",
      mods = "CTRL|ALT",
      action = wezterm.action({ ActivatePaneDirection = "Up" }),
   },
   {
      key = "j",
      mods = "CTRL|ALT",
      action = wezterm.action({ ActivatePaneDirection = "Down" }),
   },
   {
      key = "h",
      mods = "CTRL|SHIFT|ALT",
      action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }),
   },
   {
      key = "l",
      mods = "CTRL|SHIFT|ALT",
      action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }),
   },
   {
      key = "k",
      mods = "CTRL|SHIFT|ALT",
      action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }),
   },
   {
      key = "j",
      mods = "CTRL|SHIFT|ALT",
      action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }),
   },
   { -- browser-like bindings for tabbing
      key = "t",
      mods = "CTRL",
      action = wezterm.action({ SpawnTab = "DefaultDomain" }),
   },
   {
      key = "t",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnTab({
         DomainName = "WSL:Ubuntu",
      }),
   },
   {
      key = "w",
      mods = "CTRL",
      action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
   },
   {
      key = "Tab",
      mods = "CTRL",
      action = wezterm.action({ ActivateTabRelative = 1 }),
   },
   {
      key = "Tab",
      mods = "CTRL|SHIFT",
      action = wezterm.action({ ActivateTabRelative = -1 }),
   }, -- standard copy/paste bindings
   {
      key = "x",
      mods = "CTRL",
      action = "ActivateCopyMode",
   },
   {
      key = "v",
      mods = "CTRL|SHIFT",
      action = wezterm.action({ PasteFrom = "Clipboard" }),
   },
   {
      key = "c",
      mods = "CTRL|SHIFT",
      action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
   },
   {
      key = "F",
      mods = "SHIFT|CTRL",
      action = wezterm.action.Search({ CaseInSensitiveString = "" }),
   },
   {
      key = "x",
      mods = "CTRL|SHIFT",
      action = wezterm.action_callback(function(win, pane)
         wezterm.background_child_process({
            "pwsh",
            "-c",
            "x11",
         })
      end),
   },
   { key = "t", mods = "ALT", action = wezterm.action.ShowTabNavigator },
   { key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },

   generate_keys("d"),
   generate_keys("'"),
   generate_keys(";"),
   generate_keys("["),
   generate_keys("]"),
   generate_keys("\\"),
   generate_keys("j"),
   generate_keys("k"),
   generate_keys("q"),
   generate_keys("l"),
   generate_keys("h"),
   generate_keys("s"),
   generate_keys("1"),
   generate_keys("2"),
   generate_keys("3"),
   generate_keys("4"),
   generate_keys("5"),
   generate_keys("6"),
   generate_keys("7"),
   generate_keys("8"),
   generate_keys("9"),
}
