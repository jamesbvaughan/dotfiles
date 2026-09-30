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
        command: [Quickshell.env("HOME") + "/.dotfiles/scripts/khal.py"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    // khal.py escapes for Waybar's Pango markup; the bar label is plain text
                    if (data.text) root.eventText = root.decodeEntities(data.text);
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

    function decodeEntities(s) {
        const named = { amp: "&", lt: "<", gt: ">", quot: "\"", apos: "'" };
        return s.replace(/&(#x[0-9a-f]+|#[0-9]+|[a-z]+);/gi, (m, e) => {
            if (e[0] !== "#") return named[e.toLowerCase()] ?? m;
            return String.fromCodePoint(e[1] === "x" || e[1] === "X" ? parseInt(e.slice(2), 16) : parseInt(e.slice(1), 10));
        });
    }

    function openCalendar() {
        Quickshell.execDetached(["xdg-open", "https://calendar.notion.so"]);
    }
}
