// modules/updates/UpdatesView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"

    visible:        Updates.hasUpdates
    implicitWidth:  visible ? (isHorizontal ? chip.implicitWidth  : barThickness)    : 0
    implicitHeight: visible ? (isHorizontal ? chip.implicitHeight : vertPill.height) : 0

    // ── Horizontal: single chip ───────────────────────────────────────────
    Chip {
        id: chip
        visible:          root.isHorizontal
        anchors.centerIn: parent
        icon:    "󰚰"
        label:   Updates.updateCount + ""
        size:    root.barThickness
        barFont: root.barFont
        bgColor: Colors.color7
        fgColor: Colors.background
    }

    // ── Vertical: single pill, icon over value ────────────────────────────
    Rectangle {
        id: vertPill
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        width:  root.barThickness
        height: vertInner.implicitHeight + root.barThickness * 0.6
        radius: root.barThickness / 2
        color:  Colors.color3

        Column {
            id: vertInner
            anchors.centerIn: parent
            spacing: 0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           "󰚰"
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.40
                color:          Colors.background
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           Updates.updateCount + ""
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.34
                font.weight:    Font.Bold
                color:          Colors.background
            }
        }
    }
}
