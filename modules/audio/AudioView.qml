// modules/audio/AudioView.qml  — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.components

Item {
    id: root
    property bool   isHorizontal: true
    property real   barThickness: 28
    property bool   inPill:       false
    property string barFont:      "JetBrainsMono Nerd Font"

    implicitWidth:  isHorizontal ? hRow.implicitWidth : barThickness
    implicitHeight: isHorizontal ? barThickness       : vCol.implicitHeight

    // ── Horizontal: two chips side by side ───────────────────────────────
    Row {
        id: hRow
        visible:          root.isHorizontal
        anchors.centerIn: parent
        spacing: 6

        Chip {
            icon:    Audio.speakerIcon
            label:   Audio.sinkMuted ? "muted" : Audio.sinkVolume + "%"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: root.inPill ? "transparent" : (Audio.sinkMuted ? Colors.color1 : Colors.color0)
            onClicked:      Audio.muteSink()
            onScrolled: (d) => Audio.setSinkVolume(Math.max(0, Math.min(100, Audio.sinkVolume + d * 5)))
        }
        Chip {
            icon:    Audio.micIcon
            label:   Audio.srcMuted ? "muted" : Audio.srcVolume + "%"
            size:    root.barThickness
            barFont: root.barFont
            bgColor: root.inPill ? "transparent" : (Audio.srcMuted ? Colors.color1 : Colors.color0)
            onClicked:      Audio.muteSrc()
            onScrolled: (d) => Audio.setSrcVolume(Math.max(0, Math.min(100, Audio.srcVolume + d * 5)))
        }
    }

    // ── Vertical: two pills stacked, each with icon over value ───────────
    Column {
        id: vCol
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        spacing: 4

        // Speaker pill
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:  root.barThickness
            height: speakerInner.implicitHeight + root.barThickness * 0.6
            radius: root.inPill ? 0 : root.barThickness / 2
            color:  root.inPill ? "transparent" : (Audio.sinkMuted ? Colors.color1 : Colors.color0)

            Behavior on color { ColorAnimation { duration: 150 } }

            Column {
                id: speakerInner
                anchors.centerIn: parent
                spacing: 0

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           Audio.speakerIcon
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.40
                    color:          Colors.foreground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           Audio.sinkMuted ? "muted" : Audio.sinkVolume + "%"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.34
                    font.weight:    Font.Bold
                    color:          Colors.foreground
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked:    Audio.muteSink()
                onWheel: (e) => Audio.setSinkVolume(Math.max(0, Math.min(100, Audio.sinkVolume + (e.angleDelta.y > 0 ? 1 : -1) * 5)))
            }
        }

        // Mic pill
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:  root.barThickness
            height: micInner.implicitHeight + root.barThickness * 0.6
            radius: root.inPill ? 0 : root.barThickness / 2
            color:  root.inPill ? "transparent" : (Audio.srcMuted ? Colors.color1 : Colors.color0)

            Behavior on color { ColorAnimation { duration: 150 } }

            Column {
                id: micInner
                anchors.centerIn: parent
                spacing: 0

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           Audio.micIcon
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.40
                    color:          Colors.foreground
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           Audio.srcMuted ? "muted" : Audio.srcVolume + "%"
                    font.family:    root.barFont
                    font.pixelSize: root.barThickness * 0.34
                    font.weight:    Font.Bold
                    color:          Colors.foreground
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked:    Audio.muteSrc()
                onWheel: (e) => Audio.setSrcVolume(Math.max(0, Math.min(100, Audio.srcVolume + (e.angleDelta.y > 0 ? 1 : -1) * 5)))
            }
        }
    }
}
