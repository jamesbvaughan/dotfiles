import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import ".."
import "../components"
import "../services"

Scope {
    id: root

    readonly property int maxToasts: 4
    readonly property int defaultTimeoutMs: 6000

    // Visible toasts, newest first, as { notification, expiresAt }. A toast is only a view:
    // hiding it leaves the notification in the Control Center (except transient ones).
    property var toasts: []

    function show(notif) {
        const timeout = notif.urgency === NotificationUrgency.Critical ? Infinity
            : (notif.expireTimeout > 0 ? notif.expireTimeout * 1000 : defaultTimeoutMs);
        const shown = [{ notification: notif, expiresAt: Date.now() + timeout }, ...toasts];
        shown.slice(maxToasts).forEach(t => retire(t.notification));
        toasts = shown.slice(0, maxToasts);
    }

    function hide(notif) {
        if (!toasts.some(t => t.notification === notif)) return;
        toasts = toasts.filter(t => t.notification !== notif);
        retire(notif);
    }

    // Transient notifications have no place in the notification area once their toast is gone
    function retire(notif) {
        if (notif.transient && notif.tracked) notif.expire();
    }

    Connections {
        target: NotificationService

        function onReceived(notif) {
            if (!ShellState.dndEnabled) root.show(notif);
        }
    }

    // One clock for all toasts, so the list can be rebuilt freely without resetting timers
    Timer {
        interval: 500
        repeat: true
        running: root.toasts.length > 0
        onTriggered: {
            const now = Date.now();
            root.toasts.filter(t => t.expiresAt <= now).forEach(t => root.hide(t.notification));
        }
    }

    LazyLoader {
        active: root.toasts.length > 0

        PanelWindow {
            anchors.top: true
            anchors.right: true
            margins.top: Theme.barHeight + 10
            margins.right: 12
            exclusiveZone: 0

            implicitWidth: 420
            implicitHeight: toastColumn.implicitHeight
            color: "transparent"

            Column {
                id: toastColumn
                width: parent.width
                spacing: 8

                Repeater {
                    model: root.toasts

                    delegate: NotificationCard {
                        required property var modelData
                        notification: modelData.notification
                        width: toastColumn.width
                        maxBodyLines: 3
                        color: Theme.bg
                        border.color: notification.urgency === NotificationUrgency.Critical ? Theme.red : Theme.borderFocused

                        onCloseRequested: root.hide(notification)
                        onActivated: root.hide(notification)

                        // Closed elsewhere: by the app, an action, or the Control Center
                        Connections {
                            target: notification
                            function onClosed() {
                                root.toasts = root.toasts.filter(t => t.notification !== notification);
                            }
                        }
                    }
                }
            }
        }
    }
}
