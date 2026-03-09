// modules/clock/ClockView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"

    readonly property string timeHour: Clock.time.split(":")[0] ?? ""
    readonly property string timeMin:  Clock.time.split(":")[1] ?? ""

    implicitWidth:  isHorizontal ? chip.implicitWidth : barThickness
    implicitHeight: isHorizontal ? barThickness       : vertPill.height

    // ── Horizontal: single pill ───────────────────────────────────────────
    Chip {
        id: chip
        visible:          root.isHorizontal
        anchors.centerIn: parent
        icon:    ""
        label:   Clock.time
        size:    root.barThickness
        barFont: root.barFont
        bgColor: Colors.color0
    }

    // ── Vertical: single pill, hours over minutes ─────────────────────────
    Rectangle {
        id: vertPill
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        width:   root.barThickness
        height:  vertInner.implicitHeight + root.barThickness * 0.6
        radius:  root.barThickness / 2
        color:   Colors.color0

        Column {
            id: vertInner
            anchors.centerIn: parent
            spacing: 0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           root.timeHour
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.48
                font.weight:    Font.Bold
                color:          Colors.foreground
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           root.timeMin
                font.family:    root.barFont
                font.pixelSize: root.barThickness * 0.48
                font.weight:    Font.Bold
                color:          Colors.foreground
            }
        }
    }
}
