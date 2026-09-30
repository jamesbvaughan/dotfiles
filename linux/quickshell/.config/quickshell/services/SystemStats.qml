pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: 0
    property int memUsage: 0
    property int temperature: 0
    property string wattage: "0.0W"
    property int failedUnits: 0

    // Framework Laptop properties
    property int fanRpm: 0
    property int chargeLimit: 100

    // Disk usage properties
    property int diskUsage: 0
    property string diskUsed: ""
    property string diskAvail: ""
    property string diskTotal: ""

    // Internal tracking for CPU delta
    property var lastCpu: ({ total: 0, idle: 0 })

    FileView {
        id: statFile
        path: "/proc/stat"
    }

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
    }

    // hwmon and thermal_zone numbering is not stable across boots, so these two are
    // located by name at startup (see sysfsProbe). zone0 is acpitz, not the CPU.
    FileView {
        id: tempFile
    }

    FileView {
        id: fanFile
    }

    FileView {
        id: kblightFile
        path: "/sys/class/leds/chromeos::kbd_backlight/brightness"
    }

    FileView {
        id: kblightMaxFile
        path: "/sys/class/leds/chromeos::kbd_backlight/max_brightness"
    }

    Process {
        id: sysfsProbe
        running: true
        command: ["sh", "-c",
            "for z in /sys/class/thermal/thermal_zone*; do [ \"$(cat $z/type)\" = x86_pkg_temp ] && echo \"temp $z/temp\"; done;" +
            "for h in /sys/class/hwmon/hwmon*; do [ \"$(cat $h/name)\" = cros_ec ] && echo \"fan $h/fan1_input\"; done"]
        stdout: SplitParser {
            onRead: line => {
                const [kind, path] = line.split(" ");
                if (kind === "temp") tempFile.path = path;
                else if (kind === "fan") fanFile.path = path;
            }
        }
    }

    FileView {
        id: currentNowFile
        path: "/sys/class/power_supply/BAT1/current_now"
    }

    FileView {
        id: voltageNowFile
        path: "/sys/class/power_supply/BAT1/voltage_now"
    }

    // Process to check systemd failed units
    Process {
        id: failedUnitsProc
        command: ["sh", "-c", "systemctl --user list-units --state=failed --no-legend 2>/dev/null | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                const count = parseInt(this.text.trim());
                if (!isNaN(count)) {
                    root.failedUnits = count;
                }
            }
        }
    }

    // Process to check disk usage
    Process {
        id: diskProc
        command: ["sh", "-c", "df -h / | awk 'NR==2 {print $2, $3, $4, $5}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(/\s+/);
                if (parts.length >= 4) {
                    root.diskTotal = parts[0];
                    root.diskUsed = parts[1];
                    root.diskAvail = parts[2];
                    const pct = parseInt(parts[3].replace("%", ""));
                    if (!isNaN(pct)) {
                        root.diskUsage = pct;
                    }
                }
            }
        }
    }

    // The charge limit only changes when toggled, and reading it needs sudo framework_tool,
    // so it's read once at startup and after each toggle rather than polled.
    Process {
        id: chargeLimitProc
        running: true
        command: [Quickshell.env("HOME") + "/.dotfiles/scripts/framework.sh", "charge-limit", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim());
                if (!isNaN(val)) root.chargeLimit = val;
            }
        }
    }

    function toggleChargeLimit() {
        if (chargeLimitProc.running) return;
        chargeLimitProc.command = [Quickshell.env("HOME") + "/.dotfiles/scripts/framework.sh", "charge-limit", "toggle"];
        chargeLimitProc.running = true;
    }

    function readInt(file) {
        if (!file.path) return NaN;
        file.reload();
        return parseInt(file.text().trim());
    }

    function updateStats() {
        // 1. Memory
        meminfoFile.reload();
        const memText = meminfoFile.text();
        if (memText && memText.length > 0) {
            const totalMatch = memText.match(/MemTotal:\s+(\d+)/);
            const availMatch = memText.match(/MemAvailable:\s+(\d+)/);
            if (totalMatch && availMatch) {
                const total = parseInt(totalMatch[1]);
                const avail = parseInt(availMatch[1]);
                if (total > 0) {
                    root.memUsage = Math.round(((total - avail) / total) * 100);
                }
            }
        }

        // 2. CPU
        statFile.reload();
        const statText = statFile.text();
        if (statText && statText.length > 0) {
            const cpuLine = statText.split("\n")[0];
            const parts = cpuLine.trim().split(/\s+/).slice(1).map(Number);
            if (parts.length >= 4) {
                const idle = parts[3];
                const total = parts.reduce((a, b) => a + b, 0);

                if (root.lastCpu.total > 0) {
                    const totalDelta = total - root.lastCpu.total;
                    const idleDelta = idle - root.lastCpu.idle;
                    if (totalDelta > 0) {
                        root.cpuUsage = Math.max(0, Math.min(100, Math.round(((totalDelta - idleDelta) / totalDelta) * 100)));
                    }
                }
                root.lastCpu = { total: total, idle: idle };
            }
        }

        // 3. Temperature, fan, keyboard backlight
        const rawTemp = readInt(tempFile);
        if (!isNaN(rawTemp)) root.temperature = Math.round(rawTemp / 1000);

        const rpm = readInt(fanFile);
        if (!isNaN(rpm)) root.fanRpm = rpm;

        const kb = readInt(kblightFile);
        const kbMax = readInt(kblightMaxFile);
        if (!isNaN(kb) && kbMax > 0 && !ShellState.isSettingKblight) {
            ShellState.kblightPercent = Math.round(kb * 100 / kbMax);
        }

        // 4. Wattage
        currentNowFile.reload();
        voltageNowFile.reload();
        const curText = currentNowFile.text().trim();
        const voltText = voltageNowFile.text().trim();
        if (curText && voltText) {
            const cur = parseInt(curText);
            const volt = parseInt(voltText);
            if (!isNaN(cur) && !isNaN(volt)) {
                const watts = (cur * volt) / 1000000000000.0;
                root.wattage = watts.toFixed(1) + "W";
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.updateStats();
        }
    }

    Timer {
        interval: 15000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            failedUnitsProc.running = true;
            diskProc.running = true;
        }
    }
}
