pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string eventText: ""
    property string tooltipText: "Loading calendar..."

    Process {
        id: khalProc
        command: ["python3", Quickshell.env("HOME") + "/.config/waybar/scripts/khal.py"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    if (data.text) root.eventText = data.text;
                    if (data.tooltip) root.tooltipText = data.tooltip;
                } catch(e) {
                    if (this.text && this.text.trim().length > 0) {
                        root.eventText = this.text.trim();
                    }
                }
            }
        }
    }

    Timer {
        interval: 300000 // 5 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: khalProc.running = true
    }

    function openCalendar() {
        Quickshell.execDetached(["xdg-open", "https://calendar.notion.so"]);
    }
}
