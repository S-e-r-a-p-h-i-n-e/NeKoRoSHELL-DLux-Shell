// quickshell/components/widgets/Clock.qml
import QtQuick
import "../../shared"

Rectangle {
    property alias clockFont: label.font.family
    property alias clockSize: label.font.pixelSize
    width: label.implicitWidth + 30
    radius: height / 2
    height: parent.height / 1.65

    color: Colors.color7
    border.width: 0
    border.color: Colors.background 

    Text {
        id: label
        anchors.centerIn: parent
        color: Colors.background 
        text: Time.time
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        font.weight: Font.ExtraBold
    }
}