local wezterm = require("wezterm")

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_wayland = true
config.warn_about_missing_glyphs = false

-- font and color scheme
config.font = wezterm.font("Martian Mono")
config.font_size = 12
config.line_height = 1.0
config.color_scheme = "Github"

-- tab bar
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

-- tab bar customization
local palette = {
  base = "#d1d5da",
  overlay = "#24292e",
  muted = "#504945",
  text = "#e0def4",
  love = "#fb4934",
  gold = "#fabd2f",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
  highlight_high = "#524f67",
}

local active_tab = {
  bg_color = palette.overlay,
  fg_color = palette.text,
}

local inactive_tab = {
  bg_color = palette.base,
  fg_color = palette.muted,
}

config.colors = {
  tab_bar = {
    background = palette.base,
    active_tab = active_tab,
    inactive_tab = inactive_tab,
    inactive_tab_hover = active_tab,
    new_tab = inactive_tab,
    new_tab_hover = active_tab,
    inactive_tab_edge = palette.muted, -- (Fancy tab bar only)
  },
}

-- shell
config.default_prog = { "/bin/zsh" }
config.default_cwd = "~/"

-- window decorations
config.window_decorations = "RESIZE"
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- background
config.window_background_opacity = 1

-- window padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Launch menu
config.launch_menu = {
  {
    label = "Work VPN",
    domain = { DomainName = "SSH:officevpn" },
  },
  {
    label = "Workstation",
    domain = { DomainName = "SSH:office_workstation" },
  },
  {
    label = "Media server",
    domain = { DomainName = "SSH:media_server" },
  },
}

-- keybindings
local action = wezterm.action

config.leader = {
  key = "a",
  mods = "CTRL",
}

config.keys = {
  {
    key = "|",
    mods = "LEADER|SHIFT",
    action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = '"',
    mods = "LEADER|SHIFT",
    action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "h",
    mods = "ALT",
    action = action.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "ALT",
    action = action.ActivatePaneDirection("Right"),
  },
  {
    key = "k",
    mods = "ALT",
    action = action.ActivatePaneDirection("Up"),
  },
  {
    key = "j",
    mods = "ALT",
    action = action.ActivatePaneDirection("Down"),
  },
  {
    key = "z",
    mods = "CTRL",
    action = action.TogglePaneZoomState,
  },
  {
    key = "H",
    mods = "ALT|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }),
  },
  {
    key = "J",
    mods = "ALT|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }),
  },
  {
    key = "K",
    mods = "ALT|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }),
  },
  {
    key = "L",
    mods = "ALT|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }),
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = "c",
    mods = "LEADER",
    action = action.SpawnCommandInNewTab({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "C",
    mods = "LEADER|SHIFT",
    action = action.SpawnCommandInNewTab({
      domain = "DefaultDomain",
    }),
  },
  {
    key = "1",
    mods = "ALT",
    action = action.SpawnCommandInNewTab({
      domain = {
        DomainName = "SSH:office_workstation",
      },
    }),
  },
  {
    key = "2",
    mods = "ALT",
    action = action.SpawnCommandInNewTab({
      domain = {
        DomainName = "SSH:officevpn",
      },
    }),
  },
  {
    key = "3",
    mods = "ALT",
    action = action.SpawnCommandInNewTab({
      domain = {
        DomainName = "SSH:media_server",
      },
    }),
  },
}

return config
