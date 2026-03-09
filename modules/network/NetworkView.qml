// modules/network/NetworkView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"
    property bool   inPill:       false

    implicitWidth:  isHorizontal ? chip.implicitWidth : barThickness
    implicitHeight: isHorizontal ? barThickness       : vertPill.height

    // ── Horizontal: single chip ───────────────────────────────────────────
    Chip {
        id: chip
        visible:          root.isHorizontal
        anchors.centerIn: parent
        icon:    Network.icon
        label:   Network.label
        size:    root.barThickness
        barFont: root.barFont
        bgColor: root.inPill ? "transparent" : (Network.connected ? Colors.color0 : Colors.color1)
        onClicked: Network.openSettings()
    }

    // ── Vertical: single pill, icon over label ────────────────────────────
    Rectangle {
        id: vertPill
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        width:  root.barThickness
        height: vertInner.implicitHeight + root.barThickness * 0.6
        radius: root.inPill ? 0 : root.barThickness / 2
        color:  root.inPill ? "transparent" : (Network.connected ? Colors.color0 : Colors.color1)

        Behavior on color { ColorAnimation { duration: 150 } }

        Column {
            id: vertInner
            anchors.centerIn: parent
            spacing: 0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           Network.icon
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.40
                color:          Colors.foreground
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           Network.label
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.34
                font.weight:    Font.Bold
                color:          Colors.foreground
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape:  Qt.PointingHandCursor
            onClicked:    Network.openSettings()
        }
    }
}
