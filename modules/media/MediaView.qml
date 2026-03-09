// modules/media/MediaView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"

    visible:        Media.hasPlayer
    implicitWidth:  visible ? (isHorizontal ? row.implicitWidth : barThickness) : 0
    implicitHeight: visible ? (isHorizontal ? barThickness      : col.implicitHeight) : 0

    // ── Horizontal: buttons + title chip ─────────────────────────────────
    Row {
        id: row
        visible:          root.isHorizontal
        anchors.centerIn: parent
        spacing: 4

        IconButton {
            icon:    "󰒮"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color5
            fgColor: Colors.background
            onClicked: Media.prev()
        }
        IconButton {
            icon:    Media.isPlaying ? "󰏤" : "󰐊"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color7
            fgColor: Colors.background
            onClicked: Media.toggle()
        }
        IconButton {
            icon:    "󰒭"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color5
            fgColor: Colors.background
            onClicked: Media.next()
        }

        Chip {
            visible: Media.title !== ""
            icon:    ""
            label:   Media.title
            size:    root.barThickness
            barFont: root.barFont
        }
    }

    // ── Vertical: back / play-pause / next stacked ───────────────────────
    Column {
        id: col
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        spacing: 4

        IconButton {
            anchors.horizontalCenter: parent.horizontalCenter
            icon:    "󰒮"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color5
            fgColor: Colors.background
            onClicked: Media.prev()
        }
        IconButton {
            anchors.horizontalCenter: parent.horizontalCenter
            icon:    Media.isPlaying ? "󰏤" : "󰐊"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color7
            fgColor: Colors.background
            onClicked: Media.toggle()
        }
        IconButton {
            anchors.horizontalCenter: parent.horizontalCenter
            icon:    "󰒭"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: Colors.color5
            fgColor: Colors.background
            onClicked: Media.next()
        }
    }
}
