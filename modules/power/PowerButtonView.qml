// modules/power/PowerButtonView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"
    property bool   inPill:       false

    implicitWidth:  barThickness
    implicitHeight: barThickness

    IconButton {
        anchors.centerIn: parent
        icon:    "⏻"
        size:    root.barThickness
        barFont: root.barFont
        bgColor: root.inPill ? "transparent" : Colors.color7
        fgColor: Colors.background
        onClicked: Power.openPower()
    }
}
