// panels/Settings.qml
import Quickshell
import QtQuick
import qs.components
import qs.globals

Panel {
    id: settingsPanel

    panelWidth:  420
    panelHeight: 560

    property bool bordersEnabled: Config.enableBorders

    Column {
        anchors.fill: parent
        spacing: 20

        Text {
            text:            "󰒓  Settings"
            color:           Colors.foreground
            font.family:     "JetBrainsMono Nerd Font"
            font.pixelSize:  18
            font.weight:     Font.ExtraBold
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle { width: parent.width; height: 1; color: Colors.color8; opacity: 0.5 }

        // ── Toggles ───────────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 15

            Toggle {
                labelText: "Show Borders"
                checked:   settingsPanel.bordersEnabled
                onToggled: (state) => EventBus.toggleBorders(state)
            }
        }

        Rectangle { width: parent.width; height: 1; color: Colors.color8; opacity: 0.5 }

        // ── Navbar position ───────────────────────────────────────────────
        Text {
            text:            "Navbar Position"
            color:           Colors.foreground
            font.family:     "JetBrainsMono Nerd Font"
            font.pixelSize:  14
            font.weight:     Font.Bold
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width:  130
            height: 130
            anchors.horizontalCenter: parent.horizontalCenter

            Button { anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
                     labelText: "󰁝"; labelFont: "JetBrainsMono Nerd Font"
                     buttonSize: 40; buttonColor: Colors.color7
                     onButtonClicked: EventBus.changeLocation("top") }
            Button { anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
                     labelText: "󰁅"; labelFont: "JetBrainsMono Nerd Font"
                     buttonSize: 40; buttonColor: Colors.color7
                     onButtonClicked: EventBus.changeLocation("bottom") }
            Button { anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                     labelText: "󰁍"; labelFont: "JetBrainsMono Nerd Font"
                     buttonSize: 40; buttonColor: Colors.color7
                     onButtonClicked: EventBus.changeLocation("left") }
            Button { anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                     labelText: "󰁔"; labelFont: "JetBrainsMono Nerd Font"
                     buttonSize: 40; buttonColor: Colors.color7
                     onButtonClicked: EventBus.changeLocation("right") }
        }

        Rectangle { width: parent.width; height: 1; color: Colors.color8; opacity: 0.5 }

        // ── Layout switcher ───────────────────────────────────────────────
        Text {
            text:            "Bar Layout"
            color:           Colors.foreground
            font.family:     "JetBrainsMono Nerd Font"
            font.pixelSize:  14
            font.weight:     Font.Bold
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Flow {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 40
            spacing: 2

            Repeater {
                model: ["default", "minimal", "media",
                        "01","02","03","04","05","06",
                        "07","08","09"]
                delegate: Rectangle {
                    required property string modelData
                    width:  80; height: 28; radius: 14
                    color:  Config.activeLayout === modelData ? Colors.color7 : Colors.color0
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text:            parent.modelData
                        color:           Config.activeLayout === parent.modelData ? Colors.background : Colors.foreground
                        font.family:     "JetBrainsMono Nerd Font"
                        font.pixelSize:  11
                        font.weight:     Font.Bold
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        onClicked:    EventBus.changeLayout(parent.modelData)
                    }
                }
            }
        }
    }
}
