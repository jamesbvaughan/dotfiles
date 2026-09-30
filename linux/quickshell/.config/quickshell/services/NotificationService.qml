pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    // Every incoming notification, after it has been tracked (toasts listen to this)
    signal received(Notification notification)

    readonly property var list: server.trackedNotifications.values
    readonly property int count: list.length

    function dismissAll() {
        const notifs = list.slice();
        for (let i = notifs.length - 1; i >= 0; i--) {
            notifs[i].dismiss();
        }
    }

    // Runs the notification's "default" action (what a click on it should do), if it has one
    function activate(notification) {
        const actions = notification.actions;
        for (let i = 0; i < actions.length; i++) {
            if (actions[i].identifier === "default") {
                actions[i].invoke();
                return true;
            }
        }
        return false;
    }

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;
            root.received(notif);
        }
    }
}
