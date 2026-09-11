import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Services.UPower
import ".."
import "../services"

Scope {
    id: root

    property alias locked: sessionLock.locked
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property string statusMessage: "Scan fingerprint or enter password"

    onCurrentTextChanged: {
        showFailure = false;
        if (!unlockInProgress) {
            statusMessage = "Scan fingerprint or enter password";
        }
    }

    // Password PAM Context
    PamContext {
        id: passwdPam
        configDirectory: Quickshell.shellDir + "/pam"
        config: "passwd.conf"

        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            root.unlockInProgress = false;
            if (result === PamResult.Success) {
                root.currentText = "";
                root.statusMessage = "Unlocked";
                sessionLock.locked = false;
            } else {
                root.currentText = "";
                root.showFailure = true;
                root.statusMessage = "Incorrect password";
                // Resume fingerprint scanner
                if (sessionLock.locked) {
                    fprintRetryTimer.restart();
                }
            }
        }
    }

    // Fingerprint PAM Context
    PamContext {
        id: fprintPam
        configDirectory: Quickshell.shellDir + "/pam"
        config: "fprint.conf"

        onPamMessage: {
            if (this.message && this.message.length > 0) {
                const msg = this.message.trim();
                // Filter out verbose initial CLI placement prompts (e.g. "Place your right index finger on the fingerprint reader")
                // so the prompt remains the clean "Scan fingerprint or enter password"
                if (/^(Place|Swipe) your/i.test(msg)) {
                    return;
                }
                root.statusMessage = msg;
            }
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.statusMessage = "Unlocked";
                root.currentText = "";
                sessionLock.locked = false;
            } else {
                root.showFailure = true;
                if (!root.statusMessage || root.statusMessage === "Scan fingerprint or enter password") {
                    root.statusMessage = "Fingerprint not recognized";
                }
                // If fingerprint failed/timed out and user isn't entering password, retry
                if (sessionLock.locked && !root.unlockInProgress) {
                    fprintRetryTimer.restart();
                }
            }
        }
    }

    Timer {
        id: fprintRetryTimer
        interval: 1200
        repeat: false
        onTriggered: {
            if (sessionLock.locked && !root.unlockInProgress && !fprintPam.active) {
                root.showFailure = false;
                root.statusMessage = "Scan fingerprint or enter password";
                fprintPam.start();
            }
        }
    }

    function tryPasswordUnlock() {
        if (currentText === "" || unlockInProgress) return;
        unlockInProgress = true;
        statusMessage = "Verifying password...";
        if (fprintPam.active) {
            fprintPam.abort();
        }
        passwdPam.start();
    }

    function startLockSession() {
        root.currentText = "";
        root.unlockInProgress = false;
        root.showFailure = false;
        root.statusMessage = "Scan fingerprint or enter password";
        if (!fprintPam.active) {
            fprintPam.start();
        }
    }

    function stopLockSession() {
        if (fprintPam.active) fprintPam.abort();
        if (passwdPam.active) passwdPam.abort();
        fprintRetryTimer.stop();
        root.currentText = "";
        root.unlockInProgress = false;
        root.showFailure = false;
        root.statusMessage = "Scan fingerprint or enter password";
    }

    WlSessionLock {
        id: sessionLock
        locked: false

        onLockedChanged: {
            if (locked) {
                root.startLockSession();
            } else {
                root.stopLockSession();
            }
        }

        onSecureChanged: {
            if (secure) {
                root.startLockSession();
            }
        }

        WlSessionLockSurface {
            id: surface
            color: Theme.bg

            FocusScope {
                id: lockFocusScope
                anchors.fill: parent
                focus: true

                // Multi-stage timers to guarantee focus after compositor window mapping
                Timer {
                    id: focusTimer1
                    interval: 50
                    running: sessionLock.locked
                    onTriggered: pwdInput.forceActiveFocus()
                }
                Timer {
                    id: focusTimer2
                    interval: 150
                    running: sessionLock.locked
                    onTriggered: pwdInput.forceActiveFocus()
                }
                Timer {
                    id: focusTimer3
                    interval: 350
                    running: sessionLock.locked
                    onTriggered: pwdInput.forceActiveFocus()
                }

                Component.onCompleted: pwdInput.forceActiveFocus()

                Connections {
                    target: surface
                    function onVisibleChanged() {
                        if (surface.visible) pwdInput.forceActiveFocus();
                    }
                }

                Connections {
                    target: sessionLock
                    function onSecureChanged() {
                        if (sessionLock.secure) pwdInput.forceActiveFocus();
                    }
                }

                // Global key catcher: typing anywhere routes focus directly to password input
                Keys.onPressed: event => {
                    if (!pwdInput.activeFocus) {
                        pwdInput.forceActiveFocus();
                    }
                }

                // Background click catcher to regain focus
                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: pwdInput.forceActiveFocus()
                }

                // Top right battery info
                Row {
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 40
                    }
                    spacing: 8

                    Text {
                        readonly property real pct: (UPower.displayDevice?.percentage ?? 1.0) * 100
                        readonly property int state: UPower.displayDevice?.state ?? 0
                        readonly property bool isCharging: state === 1 || state === 5
                        readonly property bool isPlugged: state === 4

                        text: {
                            if (isCharging) return "󰂄";
                            if (isPlugged) return "";
                            if (pct <= 15) return "";
                            if (pct <= 35) return "";
                            if (pct <= 60) return "";
                            if (pct <= 85) return "";
                            return "";
                        }
                        font.family: Theme.iconFont
                        font.pixelSize: Theme.fontSizeLarge
                        color: (isCharging || isPlugged) ? Theme.green : (pct <= 20 ? Theme.red : (pct <= 35 ? Theme.orange : Theme.fg))
                    }
                    Text {
                        text: Math.round((UPower.displayDevice?.percentage ?? 1.0) * 100) + "%"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: Theme.fg
                    }
                }

                // Center Column: Clock, Date, Media, Password input
                Item {
                    anchors.centerIn: parent
                    width: 440
                    height: centerCol.implicitHeight

                    Column {
                        id: centerCol
                        width: parent.width
                        spacing: 24

                        // Time
                        Text {
                            id: lockClock
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeLockClock
                            font.bold: true
                            color: Theme.fg
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Date
                        Text {
                            id: lockDate
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.blue
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Timer {
                            id: lockClockTimer
                            interval: 1000
                            running: true
                            repeat: true
                            triggeredOnStart: true
                            onTriggered: {
                                const d = new Date();
                                const h = d.getHours().toString().padStart(2, '0');
                                const m = d.getMinutes().toString().padStart(2, '0');
                                const s = d.getSeconds().toString().padStart(2, '0');
                                lockClock.text = `${h}:${m}:${s}`;
                                lockDate.text = Qt.formatDateTime(d, "dddd, MMMM d, yyyy");
                            }
                        }

                        // Media playback info (if any)
                        Item {
                            width: parent.width
                            height: mediaRow.visible ? 36 : 0
                            visible: mediaRow.visible

                            Row {
                                id: mediaRow
                                anchors.centerIn: parent
                                spacing: 10
                                visible: MediaService.showMedia && MediaService.trackTitle !== ""

                                Text {
                                    text: "🎵"
                                    font.pixelSize: 18
                                }
                                Text {
                                    text: MediaService.trackLabel
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.fgDim
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        // Password Input Field
                        Rectangle {
                            width: parent.width
                            height: 52
                            color: Theme.surface
                            border.color: root.showFailure ? Theme.red : (pwdInput.activeFocus ? Theme.blue : Theme.borderFocused)
                            border.width: pwdInput.activeFocus ? 2 : 1
                            anchors.horizontalCenter: parent.horizontalCenter

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16

                                TextField {
                                    id: pwdInput
                                    Layout.fillWidth: true
                                    echoMode: TextInput.Password
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeNormal
                                    color: Theme.fg
                                    placeholderText: "Enter password..."
                                    placeholderTextColor: Theme.fgMuted
                                    background: Item {}
                                    focus: true

                                    enabled: !root.unlockInProgress
                                    onTextChanged: root.currentText = this.text
                                    onAccepted: root.tryPasswordUnlock()

                                    Connections {
                                        target: root
                                        function onCurrentTextChanged() {
                                            if (root.currentText === "" && pwdInput.text !== "") {
                                                pwdInput.text = "";
                                            }
                                        }
                                    }

                                    Keys.onEscapePressed: {
                                        root.currentText = "";
                                        pwdInput.text = "";
                                    }
                                }

                                Text {
                                    text: "⏎"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeNormal
                                    color: root.currentText.length > 0 ? Theme.green : Theme.fgMuted
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.tryPasswordUnlock()
                                    }
                                }
                            }
                        }

                        // Status Message / Error
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 8

                            Text {
                                visible: !root.showFailure
                                text: "󰈀"
                                font.family: Theme.iconFont
                                font.pixelSize: Theme.fontSizeNormal
                                color: Theme.blue
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: root.statusMessage
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                color: root.showFailure ? Theme.red : Theme.fgDim
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
