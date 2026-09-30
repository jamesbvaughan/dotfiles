import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import ".."
import "../services"

Scope {
    id: root

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property string statusMessage: "Scan fingerprint or enter password"

    // Fingerprint attempt tracking: only a real "no match" is shown as a failure;
    // timeouts and device errors (e.g. stale sessions after resume) retry silently with backoff
    property bool fprintMismatch: false
    property real fprintStartedAt: 0
    property int fprintFastFailures: 0

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
                // Timeouts and device errors happen without any user interaction; stay quiet
                if (/^(Verification timed out|An unknown error|An unexpected error)/i.test(msg)) {
                    return;
                }
                if (/^Failed to match/i.test(msg)) {
                    root.fprintMismatch = true;
                    root.showFailure = true;
                    root.statusMessage = "Fingerprint not recognized";
                    return;
                }
                // Actionable scan hints (too short, not centered, ...)
                root.statusMessage = msg;
            }
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.fprintFastFailures = 0;
                root.statusMessage = "Unlocked";
                root.currentText = "";
                sessionLock.locked = false;
                return;
            }
            if (!sessionLock.locked || root.unlockInProgress) return;

            if (root.fprintMismatch) {
                root.fprintFastFailures = 0;
                fprintRetryTimer.interval = 1200;
            } else {
                // No finger involved: timed out or the device errored. Sessions that die
                // almost immediately (e.g. right after resume) back off exponentially.
                const elapsed = Date.now() - root.fprintStartedAt;
                root.fprintFastFailures = elapsed < 5000 ? root.fprintFastFailures + 1 : 0;
                fprintRetryTimer.interval = Math.min(1200 * Math.pow(2, root.fprintFastFailures), 30000);
            }
            fprintRetryTimer.restart();
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
                root.startFprint();
            }
        }
    }

    function startFprint() {
        fprintMismatch = false;
        fprintStartedAt = Date.now();
        fprintPam.start();
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
        root.fprintFastFailures = 0;
        if (!fprintPam.active) {
            root.startFprint();
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

    Connections {
        target: ShellState
        function onLockRequested() {
            sessionLock.locked = true;
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: false

        // Only on lock/unlock: also restarting on `secure` reset the session a second time,
        // wiping anything typed before the compositor confirmed the lock
        onLockedChanged: {
            if (locked) {
                root.startLockSession();
            } else {
                root.stopLockSession();
            }
        }

        WlSessionLockSurface {
            id: surface
            color: Theme.bg

            FocusScope {
                id: lockFocusScope
                anchors.fill: parent
                focus: true

                // Giving the field focus within the surface is enough: it gets active focus as
                // soon as the compositor hands the surface the keyboard
                Component.onCompleted: pwdInput.forceActiveFocus()

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
                        text: BatteryService.icon
                        font.family: Theme.iconFont
                        font.pixelSize: Theme.fontSizeLarge
                        color: BatteryService.color
                    }
                    Text {
                        text: Math.round(BatteryService.percent) + "%"
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
