// modules/systeminfo/SystemInfoView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property string barFont:      "JetBrainsMono Nerd Font"
    property bool   inPill:       false

    implicitWidth:  isHorizontal ? hRow.implicitWidth : barThickness
    implicitHeight: isHorizontal ? barThickness       : vCol.implicitHeight

    // ── Horizontal: chips side by side ───────────────────────────────────
    Row {
        id: hRow
        visible:          root.isHorizontal
        anchors.centerIn: parent
        spacing: 6

        Chip {
            icon:    "󰍛"
            label:   SystemInfo.cpuPercent + "%"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: root.inPill ? "transparent" : Colors.color0
            onClicked: SystemInfo.openMonitor()
        }
        Chip {
            icon:    "󰾆"
            label:   SystemInfo.memPercent + "%"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: root.inPill ? "transparent" : Colors.color0
            onClicked: SystemInfo.openMonitor()
        }
        Chip {
            visible: SystemInfo.gpuText !== ""
            icon:    "󰢮"
            label:   SystemInfo.gpuText
            size:    root.barThickness
            barFont: root.barFont
            bgColor: root.inPill ? "transparent" : Colors.color0
            onClicked: SystemInfo.openMonitor()
        }
    }

    // ── Vertical: one pill per stat, icon over value ──────────────────────
    Column {
        id: vCol
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        spacing: 4

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:  root.barThickness
            height: cpuInner.implicitHeight + root.barThickness * 0.6
            radius: root.inPill ? 0 : root.barThickness / 2
            color:  root.inPill ? "transparent" : Colors.color0

            Column {
                id: cpuInner
                anchors.centerIn: parent
                spacing: 0
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           "󰍛"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.40
                    color:          Colors.foreground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           SystemInfo.cpuPercent + "%"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.34
                    font.weight:    Font.Bold
                    color:          Colors.foreground
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked:    SystemInfo.openMonitor()
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:  root.barThickness
            height: memInner.implicitHeight + root.barThickness * 0.6
            radius: root.inPill ? 0 : root.barThickness / 2
            color:  root.inPill ? "transparent" : Colors.color0

            Column {
                id: memInner
                anchors.centerIn: parent
                spacing: 0
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           "󰾆"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.40
                    color:          Colors.foreground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           SystemInfo.memPercent + "%"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.34
                    font.weight:    Font.Bold
                    color:          Colors.foreground
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked:    SystemInfo.openMonitor()
            }
        }

        Rectangle {
            visible: SystemInfo.gpuText !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            width:  root.barThickness
            height: gpuInner.implicitHeight + root.barThickness * 0.6
            radius: root.inPill ? 0 : root.barThickness / 2
            color:  root.inPill ? "transparent" : Colors.color0

            Column {
                id: gpuInner
                anchors.centerIn: parent
                spacing: 0
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           "󰢮"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.40
                    color:          Colors.foreground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           SystemInfo.gpuText
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.34
                    font.weight:    Font.Bold
                    color:          Colors.foreground
                }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked:    SystemInfo.openMonitor()
            }
        }
    }
}
