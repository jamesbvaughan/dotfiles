pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string weatherText: "..."
    property string tooltipText: "Loading weather..."

    Process {
        id: weatherProc
        command: [Quickshell.env("HOME") + "/.dotfiles/scripts/wttr.py"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    if (data.text) root.weatherText = data.text;
                    if (data.tooltip) root.tooltipText = data.tooltip;
                } catch(e) {
                    if (this.text && this.text.trim().length > 0) {
                        root.weatherText = this.text.trim();
                    }
                }
            }
        }
    }

    Timer {
        interval: 600000 // 10 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProc.running = true
    }
}
