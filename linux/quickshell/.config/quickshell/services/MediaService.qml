pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    // Dynamically resolve the most relevant player:
    // 1. Actively playing player
    // 2. Paused player with track metadata
    // 3. Fallback to first player, or null
    readonly property var player: {
        const players = Mpris.players.values;
        if (!players || players.length === 0) return null;

        let playingPlayer = null;
        let pausedPlayerWithMetadata = null;

        for (let i = 0; i < players.length; i++) {
            const p = players[i];
            if (!p) continue;

            // Touch properties so QML tracks dependencies across all active players
            const playing = p.isPlaying;
            const title = p.trackTitle;

            if (playing && !playingPlayer) {
                playingPlayer = p;
            }
            if (title && !pausedPlayerWithMetadata) {
                pausedPlayerWithMetadata = p;
            }
        }

        return playingPlayer || pausedPlayerWithMetadata || players[0] || null;
    }

    readonly property bool hasPlayer: player !== null
    readonly property string identity: player?.identity ?? ""
    readonly property string desktopEntry: player?.desktopEntry ?? ""
    readonly property string appName: {
        if (!player) return "";
        return player.identity || player.desktopEntry || "Media";
    }
    readonly property bool isPlaying: player?.isPlaying ?? false
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property string trackArtist: player?.trackArtist ?? ""
    readonly property string trackAlbum: player?.trackAlbum ?? ""
    readonly property string trackArtUrl: player?.trackArtUrl ?? ""
    readonly property bool canControl: player?.canControl ?? false
    readonly property bool canGoNext: player?.canGoNext ?? false
    readonly property bool canGoPrevious: player?.canGoPrevious ?? false

    readonly property string trackLabel: {
        if (trackArtist && trackTitle) {
            return `${trackArtist} - ${trackTitle}`;
        }
        return trackTitle || trackArtist || "";
    }

    readonly property bool showMedia: player !== null && (trackTitle !== "" || isPlaying)

    function togglePlaying() {
        if (player) {
            player.togglePlaying();
        }
    }

    function playPause() {
        togglePlaying();
    }

    function next() {
        if (player) {
            player.next();
        }
    }

    function previous() {
        if (player) {
            player.previous();
        }
    }
}
