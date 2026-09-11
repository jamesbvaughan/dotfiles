-- See https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- Primary Apple Studio Display
hl.monitor({
  output   = "DP-1",
  mode     = "5120x2880@60Hz",
  position = "1672x0",
  scale    = 1,
})

-- Disable Apple Studio Display secondary ghost interface
hl.monitor({
  output   = "DP-2",
  disabled = true,
})

-- Laptop built-in display
hl.monitor({
  output   = "eDP-1",
  mode     = "2880x1920@120Hz",
  position = "2751x2880",
  scale    = 1,
})

-- Fallback for any other display
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = 1,
})

-- Lid switch: only disable eDP-1 when shut IF an external display is connected
hl.bind("switch:on:Lid Switch", function()
  local monitors = hl.get_monitors()
  local external = false
  for _, m in ipairs(monitors) do
    if m.name ~= "eDP-1" then
      external = true
      break
    end
  end
  if external then
    hl.monitor({ output = "eDP-1", disabled = true })
  end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
  hl.monitor({ output = "eDP-1", mode = "2880x1920@120Hz", position = "auto", scale = 1 })
end, { locked = true })


---------------------
---- MY PROGRAMS ----
---------------------

local mainMod     = "SUPER"
local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "vicinae toggle"
local lock_cmd    = "quickshell ipc call shell lock || hyprlock --grace 10"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  -- Propagate environment to systemd/dbus and start graphical session target
  hl.exec_cmd(
  "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
  hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
  hl.exec_cmd("systemctl --user start hyprland-session.target")

  -- Theme and appearance
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark")

  -- Polkit authentication agent
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  -- Background daemons / tray apps
  hl.exec_cmd("1password --silent")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("dropbox")
  hl.exec_cmd("localsend --hidden")
  hl.exec_cmd("trayscale --hide-window")

  -- Idle management and screen lock (run lock in background so swayidle does not block sleep inhibitor)
  hl.exec_cmd(
  "swayidle -w timeout 1800 'quickshell ipc call shell lock || hyprlock --grace 10' timeout 1805 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'playerctl pause' before-sleep 'sh -c \"quickshell ipc call shell lock || hyprlock --grace 10 &\"'")

  -- Wallpaper (quickshell is managed by hyprland-session.target via systemd)
  hl.exec_cmd("hyprpaper")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "xdgdesktopportal")
hl.env("QT_STYLE_OVERRIDE", "Fusion")
hl.env("GDK_BACKEND", "wayland,x11,*")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Kanagawa Dragon color palette
hl.config({
  general = {
    gaps_in       = 5,
    gaps_out      = 10,
    border_size   = 4,

    col           = {
      active_border   = "rgba(c4746eff)",
      inactive_border = "rgba(181616ff)",
    },

    layout        = "dwindle",
    allow_tearing = false,
  },

  decoration = {
    rounding = 0,

    blur = {
      enabled = true,
      size    = 3,
      passes  = 1,
    },
  },

  animations = {
    enabled = false,
  },

  gestures = {
    workspace_swipe_distance = 300,
    workspace_swipe_cancel_ratio = 0.2,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_direction_lock = true,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper  = 0,
    disable_splash_rendering = true,
    focus_on_activate        = true,
  },

  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "caps:ctrl_modifier",
    kb_rules     = "",

    repeat_rate  = 40,
    repeat_delay = 200,

    follow_mouse = 1,
    sensitivity  = 0,

    touchpad     = {
      natural_scroll          = true,
      scroll_factor           = 0.1,
      tap_to_click            = true,
      clickfinger_behavior    = true,
      middle_button_emulation = true,
      disable_while_typing    = true,
    },
  },
})

-- Animations disabled for pure instant transitions (Sway-style)
hl.animation({ leaf = "global", enabled = false })
hl.animation({ leaf = "workspaces", enabled = false })

-- Bump just the touchpad pointer speed (leaves external mouse untouched)
hl.device({
  name        = "synaptics-tm3289-002",
  sensitivity = 0.5,
})

-- Gestures (3-finger swipe across workspaces)
hl.gesture({
  fingers   = 3,
  direction = "horizontal",
  action    = "workspace",
})


------------------
---- PLUGINS -----
------------------

local hyprexpo_plugin = os.getenv("HOME") .. "/.local/share/hypr/plugins/hyprexpo.so"
hl.plugin.load(hyprexpo_plugin)

local hyprexpo_loaded = false
for _, p in ipairs(hl.get_loaded_plugins()) do
  if p.name == "hyprexpo" then
    hyprexpo_loaded = true
    break
  end
end

if hyprexpo_loaded then
  hl.config({
    plugin = {
      hyprexpo = {
        columns          = 3,
        gaps_in          = 5,
        gaps_out         = 10,
        bg_col           = "rgb(181616)",
        workspace_method = "center current",
        gesture_distance = 250,
        cancel_key       = "escape",
        show_cursor      = 1,
        drag_drop_enable = 0,
      },
    },
  })

  -- 3-finger swipe up to open macOS-style Mission Control overview
  hl.plugin.hyprexpo.gesture({
    fingers   = 3,
    direction = "up",
    action    = "expo",
  })

  -- SUPER + G toggles the Mission Control grid overview
  hl.bind(mainMod .. " + G", function()
    hl.plugin.hyprexpo.expo("toggle")
  end)

  -- Keyboard navigation when overview is open (Vim keys)
  hl.define_submap("hyprexpo", function()
    hl.bind("h", function() hl.plugin.hyprexpo.kb_focus("left") end)
    hl.bind("l", function() hl.plugin.hyprexpo.kb_focus("right") end)
    hl.bind("k", function() hl.plugin.hyprexpo.kb_focus("up") end)
    hl.bind("j", function() hl.plugin.hyprexpo.kb_focus("down") end)
    hl.bind("return", function() hl.plugin.hyprexpo.kb_confirm() end)
    hl.bind("escape", function() hl.plugin.hyprexpo.expo("cancel") end)
  end)
end


----------------------
---- SMART GAPS  -----
----------------------

-- No gaps / no border when only one tiled window or a fullscreen is on the workspace.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
  name        = "no-gaps-wtv1",
  match       = { float = false, workspace = "w[tv1]" },
  border_size = 0,
})
hl.window_rule({
  name        = "no-gaps-f1",
  match       = { float = false, workspace = "f[1]" },
  border_size = 0,
})


----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({ name = "zoom", match = { class = "Zoom" }, float = true })
hl.window_rule({ name = "nwg-displays", match = { class = "^nwg-displays$" }, float = true })
hl.window_rule({ name = "bluetui", match = { class = "^bluetui\\.Bluetui$" }, float = true, size = "900 700" })
hl.window_rule({ name = "trayscale", match = { class = "^dev\\.deedles\\.Trayscale$" }, float = true })
hl.window_rule({ name = "swayimg", match = { class = "swayimg" }, float = true, size = "1200 800" })
hl.window_rule({ name = "pavucontrol", match = { class = "pavucontrol" }, float = true, size = "900 700" })
hl.window_rule({ name = "pip", match = { title = "^Picture in picture$" }, float = true, pin = true })
hl.window_rule({ name = "easyeffects", match = { title = "^Easy Effects$" }, float = true })


---------------------
---- KEYBINDINGS ----
---------------------

-- Launch / window management
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("quickshell ipc call shell toggleNotifications"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("quickshell ipc call shell togglePowerDialog"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(os.getenv("HOME") .. "/pw"))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))

-- Move focus (Vim keys)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move window (Vim keys)
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Cycle workspaces
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "e-1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move focused workspace to adjacent display
hl.bind(mainMod .. " + CTRL + SHIFT + h", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind(mainMod .. " + CTRL + SHIFT + l", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))
hl.bind(mainMod .. " + CTRL + SHIFT + k", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor u"))
hl.bind(mainMod .. " + CTRL + SHIFT + j", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor d"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots (grimshot)
hl.bind(mainMod .. " + CTRL + 4",
  hl.dsp.exec_cmd(
  [[sh -c 'grimshot --notify savecopy area ~/screenshots/screenshot-at-$(date +"%Y-%m-%d-%H-%M-%S").png']]))
hl.bind(mainMod .. " + CTRL + 5",
  hl.dsp.exec_cmd(
  [[sh -c 'grimshot --notify savecopy output ~/screenshots/screenshot-at-$(date +"%Y-%m-%d-%H-%M-%S").png']]))

-- Media & Volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86Display", hl.dsp.exec_cmd(lock_cmd), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("quickshell ipc call shell togglePowerDialog"), { locked = true })

-- Brightness keys
hl.bind("XF86MonBrightnessUp",
  hl.dsp.exec_cmd(os.getenv("HOME") .. "/.dotfiles/scripts/brightness.sh up"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
  hl.dsp.exec_cmd(os.getenv("HOME") .. "/.dotfiles/scripts/brightness.sh down"),
  { locked = true, repeating = true })

-- Resize submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

  hl.bind("Return", hl.dsp.submap("reset"))
  hl.bind("Escape", hl.dsp.submap("reset"))
  hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
end)
