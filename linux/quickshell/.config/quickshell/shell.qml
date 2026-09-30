//@ pragma UseQApplication
//@ pragma IconTheme breeze-dark
import QtQuick
import Quickshell
import Quickshell.Io
import "modules"
import "services"

ShellRoot {
    id: root

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
    PowerDialog {}

    // Automatic Power Profile Management (AC -> Performance, Battery -> Balanced)
    PowerManagement {}

    // Session Lock Screen (ext-session-lock-v1)
    LockScreen {}

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
            ShellState.lock();
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
    }
}
