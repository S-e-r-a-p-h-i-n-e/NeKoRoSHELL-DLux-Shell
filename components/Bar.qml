// quickshell/components/Bar.qml
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "widgets"

Scope {
    id: navbar
    property color barColor
    property real barSize
    property real fontSize
    property string font: "JetBrainsMono Nerd Font"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: navbar.barColor

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: navbar.barSize

            Workspaces {
                anchors {
                    left: parent.left
                    leftMargin: 35
                }
            }

            Clock {
                anchors.centerIn: parent
                clockSize: navbar.fontSize
                clockFont: navbar.font
            }

            ButtonsRow {
                anchors {
                    right: parent.right
                    rightMargin: 35
                }
            }
        }
    }
}
