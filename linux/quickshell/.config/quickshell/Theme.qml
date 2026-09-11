pragma Singleton
import QtQuick

QtObject {
    // Kanagawa Dragon palette (flat colors)
    readonly property color bg: "#181616"
    readonly property color bgAlt: "#1f1f28"
    readonly property color surface: "#282727"
    readonly property color surfaceHover: "#343232"
    readonly property color surfaceActive: "#3c3838"
    
    readonly property color border: "#343232"
    readonly property color borderFocused: "#c4746e"

    // Accents
    readonly property color red: "#c4746e"
    readonly property color green: "#87a987"
    readonly property color blue: "#8ba4b0"
    readonly property color orange: "#b6927b"
    readonly property color yellow: "#c0a36e"
    readonly property color aqua: "#7fb4ca"
    readonly property color purple: "#957fb8"

    // Typography
    readonly property color fg: "#c5c9c5"
    readonly property color fgDim: "#8a8f8a"
    readonly property color fgMuted: "#5e635e"

    readonly property string fontFamily: "Berkeley Mono"
    readonly property string iconFont: "Symbols Nerd Font"
    readonly property var fontFamilies: ["Berkeley Mono", "Symbols Nerd Font", "monospace"]

    // Scaled typography for native 2880x1920 resolution (scale factor 1:1)
    readonly property int fontSizeSmall: 18
    readonly property int fontSizeNormal: 22
    readonly property int fontSizeLarge: 28
    readonly property int fontSizeClock: 22
    readonly property int fontSizeLockClock: 76

    // Spacing & Metrics
    readonly property int barHeight: 52
    readonly property int barPadding: 6
    readonly property int moduleSpacing: 11
    readonly property int radius: 0 // Flat sharp edges matching Sway/Hyprland rounding = 0
}
