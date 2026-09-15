//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import "modules"
import "services"

ShellRoot {
    id: root

    // Central Notification Server
    NotificationServer {
        id: notificationServer
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true
    }

    // Top Bar on each connected screen
    Variants {
        model: Quickshell.screens

        delegate: Component {
            TopBar {
                required property var modelData
                screen: modelData
            }
        }
    }

    // Bottom Bar on each connected screen
    Variants {
        model: Quickshell.screens

        delegate: Component {
            BottomBar {
                required property var modelData
                screen: modelData
            }
        }
    }

    // On-Screen Display for Volume and Brightness
    Osd {}

    // Toast Popups for Incoming Notifications
    NotificationToasts {}

    // Slide-out Notification Center & Quick Settings Drawer
    NotificationCenter {}

    // Power Confirmation & Action Dialog
    PowerDialog {
        id: powerDialog
        onLockRequested: {
            lockScreen.locked = true;
        }
    }

    // Automatic Power Profile Management (AC -> Performance, Battery -> Balanced)
    PowerManagement {}

    // Session Lock Screen (ext-session-lock-v1)
    LockScreen {
        id: lockScreen
    }

    // IPC Handler to interface with Hyprland keybinds and scripts
    IpcHandler {
        target: "shell"

        function toggleNotifications(): void {
            ShellState.toggleNotificationCenter();
        }

        function openNotifications(): void {
            ShellState.notificationCenterOpen = true;
        }

        function closeNotifications(): void {
            ShellState.closeNotificationCenter();
        }

        function togglePowerDialog(): void {
            ShellState.togglePowerDialog();
        }

        function openPowerDialog(): void {
            ShellState.openPowerDialog();
        }

        function closePowerDialog(): void {
            ShellState.closePowerDialog();
        }

        function lock(): void {
            lockScreen.locked = true;
        }

        function unlock(): void {
            lockScreen.locked = false;
        }

        function triggerBrightnessOsd(percent: int): void {
            ShellState.triggerBrightnessOsd(percent);
        }

        function triggerKblightOsd(percent: int): void {
            ShellState.triggerKblightOsd(percent);
        }

        function setKblight(percent: int): void {
            ShellState.setKblight(percent);
        }

        function showVolumeOsd(): void {
            const vol = Pipewire.defaultAudioSink?.audio.volume ?? 0;
            const muted = Pipewire.defaultAudioSink?.audio.muted ?? false;
            ShellState.triggerVolumeOsd(vol, muted);
        }
    }
}
