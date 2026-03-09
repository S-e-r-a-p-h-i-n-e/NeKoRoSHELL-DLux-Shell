// components/Chip.qml
// Icon + label pill. The universal read-only display primitive.
// Used by: audio, network, power, updates, systeminfo, clock, cava
import QtQuick
import qs.globals

Rectangle {
    id: root

    property string icon:        ""
    property string label:       ""
    property string barFont:     "JetBrainsMono Nerd Font"
    property real   size:        28
    property color  bgColor:     Colors.color0
    property color  fgColor:     Colors.foreground
    property bool   showBorder:  false

    signal clicked()
    signal rightClicked()
    signal scrolled(int delta)

    implicitHeight: size
    implicitWidth:  inner.implicitWidth + size * 0.6
    radius:         height / 2
    color:          bgColor
    border.color:   Qt.rgba(1, 1, 1, 0.08)
    border.width:   showBorder ? 1 : 0

    Behavior on color { ColorAnimation { duration: 150 } }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 5

        Text {
            visible:        root.icon !== ""
            text:           root.icon
            font.family:    root.barFont
            font.pixelSize: root.size * 0.55
            color:          root.fgColor
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            visible:        root.label !== ""
            text:           root.label
            font.family:    root.barFont
            font.pixelSize: root.size * 0.48
            font.weight:    Font.Bold
            color:          root.fgColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill:    parent
        cursorShape:     Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (e) => {
            if (e.button === Qt.RightButton) root.rightClicked()
            else                             root.clicked()
        }
        onWheel: (e) => root.scrolled(e.angleDelta.y > 0 ? 1 : -1)
    }
}
