// quickshell/components/widgets/Workspaces.qml
import QtQuick
import Quickshell.Hyprland
import "../../shared"

ListView {
    id: root
    
    orientation: ListView.Horizontal
    spacing: 13
    
    model: Hyprland.workspaces

    readonly property real delegateSize: parent.height / 1.65
    readonly property real minWorkspaces: 5
    readonly property real minCalculatedWidth: (delegateSize * minWorkspaces) + (spacing * (minWorkspaces - 1))

    implicitWidth: Math.max(contentWidth, minCalculatedWidth)
    height: parent.height

    clip: false 

    delegate: Rectangle {
        required property var modelData
        anchors.verticalCenter: parent.verticalCenter
        
        height: root.delegateSize
        width: height
        radius: height / 2
        
        Text {
            id: label
            anchors.centerIn: parent
            text: modelData.focused ? "󰣇" : modelData.name
            color: modelData.focused ? Colors.background : Colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            font.weight: Font.ExtraBold
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: modelData.activate()
        }

        color: {
            if (modelData.focused) return Colors.color7;
            return Colors.color5;
        }

        Behavior on color { ColorAnimation { duration: 150 } }
    }
}