local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- REPAIR SETTINGS (Paste this over the previous block)
-- =========================================================
-- Use OpenGL, but force the EGL library (fixes the "Not Responding" freeze)
config.front_end = "OpenGL"
config.prefer_egl = true

-- Cap FPS strictly to 60 (Fixes the "flickering/tearing" in Software mode)
config.max_fps = 60

-- Keep animations choppy but stable (Prevents the divide-by-zero crash)
config.animation_fps = 1


-- =========================================================
-- 2. APPEARANCE & SHELL
-- =========================================================
config.color_scheme = 'Catppuccin Mocha'
config.default_cursor_style = 'BlinkingBar'
config.colors = { compose_cursor = 'orange' }

-- Use Git Bash as default on Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-l" }
end

-- Fancy Right Status (Shows LEADER when active)
wezterm.on('update-right-status', function(window, pane)
  local leader = ''
  if window:leader_is_active() then
    leader = '  LEADER  '
  end
  window:set_right_status(wezterm.format({
    { Background = { Color = '#f38ba8' } }, -- Reddish background
    { Foreground = { Color = '#1e1e2e' } }, -- Dark text
    { Text = leader },
  }))
end)

-- =========================================================
-- 3. KEYBINDINGS
-- =========================================================
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Send "CTRL-A" to the terminal (Double tap Ctrl+a)
  { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },

  -- SPLITS (Matches your preference)
  { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "=", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },

  -- NAVIGATION (Vim style)
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- ZOOM (Toggle fullscreen for current pane)
  { key = 'm', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- SAFER CLOSE PANE (Moved to LEADER + w)
  -- Changed confirm to true so you don't accidentally kill your work
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- RELOAD CONFIG (Leader + r)
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },

  -- RESIZE MODE (Leader + s)
  -- Activates a special mode to resize panes with hjkl
  { key = 's', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
}

-- =========================================================
-- 4. KEY TABLES (Modes)
-- =========================================================
config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'Escape', action = 'PopKeyTable' }, -- Exit mode
    { key = 'Enter', action = 'PopKeyTable' },  -- Exit mode
  },
}

return config
