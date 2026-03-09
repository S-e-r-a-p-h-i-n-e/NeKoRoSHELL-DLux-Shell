// components/IconButton.qml
// Single circular icon button. Replaces the inline Rectangle+Text pattern.
// Used by: idleinhibitor, cliphist, wallchange, layoutswitcher, media controls
import QtQuick
import qs.globals

Rectangle {
    id: root

    property string icon:        ""
    property string barFont:     "JetBrainsMono Nerd Font"
    property real   size:        28
    property real   containerSize: size          // override to resize the circle independently
    property real   iconSize:      size * 0.6    // override to resize the glyph independently
    property color  bgColor:    Colors.color0
    property color  fgColor:    Colors.foreground
    property bool   active:     false
    property color  activeColor: Colors.color7

    signal clicked()
    signal rightClicked()
    signal scrolled(int delta)

    width:  containerSize
    height: containerSize
    radius: containerSize / 2
    color:  active ? activeColor : bgColor

    Behavior on color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text:           root.icon
        font.family:    root.barFont
        font.pixelSize: root.iconSize
        color:          root.active ? Colors.background : root.fgColor
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
