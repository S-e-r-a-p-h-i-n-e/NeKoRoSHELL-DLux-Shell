// components/ScrollText.qml
// Clipping text that scrolls when content overflows. Used by media title.
import QtQuick
import qs.globals

Item {
    id: root

    property string text:       ""
    property string barFont:    "JetBrainsMono Nerd Font"
    property real   size:       28
    property color  fgColor:    Colors.foreground
    property real   maxWidth:   120

    implicitWidth:  Math.min(inner.implicitWidth, maxWidth)
    implicitHeight: size

    clip: true

    Text {
        id: inner
        text:           root.text
        font.family:    root.barFont
        font.pixelSize: root.size * 0.48
        color:          root.fgColor
        anchors.verticalCenter: parent.verticalCenter

        NumberAnimation on x {
            running:  inner.implicitWidth > root.maxWidth
            from:     0
            to:       -(inner.implicitWidth - root.maxWidth + 16)
            duration: 4000
            loops:    Animation.Infinite
        }
    }
}
