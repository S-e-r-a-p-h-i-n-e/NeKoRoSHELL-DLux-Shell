import QtQuick

Rectangle {
    id: root
    property string labelText
    property string labelFont
    property real buttonSize: parent.height / 1.65
    property color buttonColor

    height: buttonSize
    width: height
    radius: height / 2
    color: buttonColor

    Text {
        id: label
        anchors.centerIn: parent
        text: root.labelText
        font.family: root.labelFont
        color: Colors.background
        font.pixelSize: parent.height / 1.65
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }
}