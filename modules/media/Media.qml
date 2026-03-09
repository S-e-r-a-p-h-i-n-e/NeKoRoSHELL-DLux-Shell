// modules/media/Media.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.globals

QtObject {
    readonly property var player: {
        let players = Mpris.players.values
        for (let i = 0; i < players.length; i++)
            if (players[i].playbackState === MprisPlaybackState.Playing) return players[i]
        return players.length > 0 ? players[0] : null
    }
    readonly property bool   hasPlayer: player !== null
    readonly property bool   isPlaying: player?.playbackState === MprisPlaybackState.Playing
    readonly property string title:     player ? (player.trackTitle || player.identity || "") : ""
    readonly property string artist:    player ? (player.trackArtist || "") : ""

    function play()   { player?.play() }
    function pause()  { player?.pause() }
    function toggle() { isPlaying ? pause() : play() }
    function next()   { player?.next() }
    function prev()   { player?.previous() }
}
