// modules/status/StatusView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Row {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"
    property bool   inPill:       false
    spacing: 6

    Chip {
        visible: Status.hasBattery
        icon:    Status.battIcon
        label:   Status.battPercent + "%"
        size:    root.barThickness
        barFont: root.barFont
        bgColor: root.inPill ? "transparent" : (Status.battLow ? Colors.color1 : Colors.color0)
    }

    Chip {
        visible:    Status.hasBacklight
        icon:       Status.blIcon
        label:      Status.blPercent + "%"
        size:       root.barThickness
        barFont:    root.barFont
        bgColor:    root.inPill ? "transparent" : Colors.color0
        onScrolled: (d) => Status.stepBacklight(d)
    }
}
