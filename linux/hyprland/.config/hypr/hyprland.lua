-- See https://wiki.hypr.land/Configuring/Start/

-------------------
---- CONSTANTS ----
-------------------

-- Absolute path to the dotfiles scripts directory. Always spell script paths out in
-- full: $HOME/.dotfiles/scripts is added to PATH by .zshrc, which only runs for
-- interactive shells. The graphical session never sources it -- Hyprland is started by
-- lightdm via start-hyprland -- so a bare `lock.sh` here resolves to nothing and the
-- `sh -c` wrapper exits 127 without a word. That silently disabled every lock path:
-- the lid bind did nothing, and swayidle's before-sleep hook returned instantly, which
-- released its sleep inhibitor and let the machine suspend unlocked.
local scripts = os.getenv("HOME") .. "/.dotfiles/scripts/"


------------------
---- MONITORS ----
------------------

-- Helper to check if laptop lid is physically closed
local function is_lid_closed()
  local f = io.open("/proc/acpi/button/lid/LID0/state", "r")
  if not f then return false end
  local content = f:read("*a")
  f:close()
  return content:match("closed") ~= nil
end

-- Is a real external display currently active?
-- Only trust the compositor's live output list. Do NOT read /sys/class/drm/*/status:
-- the kernel updates connector status asynchronously, so right after a Thunderbolt
-- unplug it still reports "connected" and we would wrongly keep eDP-1 disabled.
local function has_external_monitor()
  for _, m in ipairs(hl.get_monitors()) do
    if m.name ~= "eDP-1" and m.name ~= "DP-2" then
      return true
    end
  end
  return false
end

-- Primary Apple Studio Display or Pro Display XDR
hl.monitor({
  output   = "DP-1",
  mode     = "5120x2880@60Hz",
  position = "1672x0",
  scale    = 1,
})

-- Disable secondary ghost interface from dual-tile Apple displays
hl.monitor({
  output   = "DP-2",
  disabled = true,
})

-- Fallback for any other external display
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = 1,
})

-- Single source of truth for eDP-1.
--
-- Invariant: eDP-1 is disabled ONLY in true clamshell mode (lid shut AND an external
-- display is live). Every other case enables it. This both honours "lid open => panel on"
-- and guarantees the session never reaches zero enabled outputs -- a state that wedges
-- the DRM backend (the compositor reshuffles CRTCs, the panel can end up on a pipe the
-- Intel driver cannot drive, and every atomic commit then fails with EINVAL).
--
-- Note: `disabled = false` must be passed explicitly. Omitting it leaves an
-- already-disabled output disabled, no matter what mode/position you set.
local function update_monitors()
  local has_ext = has_external_monitor()

  if is_lid_closed() and has_ext then
    hl.monitor({ output = "eDP-1", disabled = true })
  else
    hl.monitor({
      output   = "eDP-1",
      mode     = "2880x1920@120Hz",
      position = has_ext and "2751x2880" or "auto",
      scale    = 1,
      disabled = false,
    })
  end
end

-- Runs on startup and on every `hyprctl reload`
update_monitors()

hl.bind("switch:on:Lid Switch", function()
  update_monitors()
  hl.exec_cmd(scripts .. "lock.sh")
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
  update_monitors()
end, { locked = true })

hl.on("monitor.added", function()
  update_monitors()
end)

hl.on("monitor.removed", function()
  -- Re-evaluate on the next tick: the departing output can still appear in
  -- hl.get_monitors() while the removal is being processed.
  hl.timer(update_monitors, { timeout = 200, type = "oneshot" })
end)


---------------------
---- MY PROGRAMS ----
---------------------

local mainMod     = "SUPER"
local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "vicinae toggle"
local lock_cmd    = scripts .. "lock.sh"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  -- Propagate environment to systemd/dbus, then start the graphical session target.
  -- Chained with && on purpose: hl.exec_cmd spawns asynchronously, so as three separate
  -- calls the target could start before the import finished. Services launched by it
  -- (quickshell) would then come up without HYPRLAND_INSTANCE_SIGNATURE and silently fail
  -- to reach Hyprland's IPC -- no workspace indicator, no window title.
  -- HYPRLAND_INSTANCE_SIGNATURE must be in both lists; it is what the IPC connects through.
  hl.exec_cmd(
    "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE" ..
    " && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE" ..
    " && systemctl --user start hyprland-session.target")

  -- Theme and appearance
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark")

  -- Background daemons / tray apps
  hl.exec_cmd("1password --silent")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("dropbox")
  hl.exec_cmd("localsend --hidden")
  hl.exec_cmd("trayscale --hide-window")

  -- Idle management and screen lock.
  -- Every hook is one absolute script path, single-quoted: no nested shell quoting to get
  -- wrong, and nothing that depends on swayidle inheriting a PATH it does not have.
  -- `resume` belongs to the preceding timeout (the user came back from idle); it is
  -- `after-resume` that fires after a suspend. There, `reload config-only` re-runs
  -- update_monitors(), so the panel comes back even if the lid-switch or dock hotplug
  -- event was missed while asleep.
  hl.exec_cmd(
    "swayidle -w" ..
    " timeout 1800 '" .. scripts .. "lock.sh'" ..
    " timeout 1805 '" .. scripts .. "dpms.sh off'" ..
    " resume '" .. scripts .. "dpms.sh on'" ..
    " before-sleep 'playerctl pause'" ..
    " before-sleep '" .. scripts .. "lock.sh --sleep'" ..
    " after-resume 'hyprctl reload config-only'")

  -- Blue light filter / color temperature
  hl.exec_cmd("hyprsunset")
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
    gaps_in                 = 5,
    gaps_out                = 10,
    border_size             = 4,

    col                     = {
      active_border   = "rgba(c4746eff)",
      inactive_border = "rgba(181616ff)",
    },

    layout                  = "dwindle",
    allow_tearing           = false,
    resize_on_border        = true,
    extend_border_grab_area = 25,
    hover_icon_on_border    = true,
  },

  decoration = {
    rounding = 0,

    blur = {
      enabled = true,
      size    = 3,
      passes  = 1,
    },
  },

  -- Instant transitions (Sway-style)
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

  -- Plain black desktop; no wallpaper daemon needed
  misc = {
    force_default_wallpaper    = 0,
    disable_hyprland_logo      = true,
    background_color           = "rgb(000000)",
    disable_splash_rendering   = true,
    focus_on_activate          = true,
    allow_session_lock_restore = true,
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
hl.window_rule({ name = "pavucontrol", match = { title = "^Volume Control$" }, float = true, size = "900 700" })
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
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + S", hl.dsp.window.pin())
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
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move focused workspace to adjacent display
hl.bind(mainMod .. " + CTRL + SHIFT + h", hl.dsp.workspace.move({ monitor = "left" }))
hl.bind(mainMod .. " + CTRL + SHIFT + l", hl.dsp.workspace.move({ monitor = "right" }))
hl.bind(mainMod .. " + CTRL + SHIFT + k", hl.dsp.workspace.move({ monitor = "up" }))
hl.bind(mainMod .. " + CTRL + SHIFT + j", hl.dsp.workspace.move({ monitor = "down" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots (grimshot)
hl.bind(mainMod .. " + CTRL + 4",
  hl.dsp.exec_cmd(
    [[grimshot --notify savecopy area ~/screenshots/screenshot-at-$(date +"%Y-%m-%d-%H-%M-%S").png]]))
hl.bind(mainMod .. " + CTRL + 5",
  hl.dsp.exec_cmd(
    [[grimshot --notify savecopy output ~/screenshots/screenshot-at-$(date +"%Y-%m-%d-%H-%M-%S").png]]))

-- Media & Volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86Display", hl.dsp.exec_cmd(lock_cmd), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("quickshell ipc call shell togglePowerDialog"), { locked = true })

-- Emergency lock reset: force clears dead lock without needing a TTY switch
hl.bind("CTRL + ALT + BackSpace", function()
  pcall(hl.clear_crashed_lockscreen)
end, { locked = true })

-- Brightness keys
hl.bind("XF86MonBrightnessUp",
  hl.dsp.exec_cmd(scripts .. "brightness.sh up"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
  hl.dsp.exec_cmd(scripts .. "brightness.sh down"),
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
