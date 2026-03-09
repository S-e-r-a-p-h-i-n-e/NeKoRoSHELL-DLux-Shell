// engine/LayoutLoader.qml
// Reads the active JSON layout and renders the bar on every screen.
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import qs.globals

Scope {
    id: root

    readonly property real   barSize:    40   // navbar window thickness
    readonly property real   moduleSize: 28   // module/pill thickness
    readonly property string barFont:    "JetBrainsMono Nerd Font"
    readonly property bool   isHorizontal: Config.isHorizontal

    property var layoutLeft:   []
    property var layoutCenter: []
    property var layoutRight:  []

    FileView {
        path: Qt.resolvedUrl("../layouts/" + Config.activeLayout + ".json")
        adapter: JsonAdapter {
            property var left:   []
            property var center: []
            property var right:  []
            onLeftChanged:   root.layoutLeft   = JSON.parse(JSON.stringify(left   || []))
            onCenterChanged: root.layoutCenter = JSON.parse(JSON.stringify(center || []))
            onRightChanged:  root.layoutRight  = JSON.parse(JSON.stringify(right  || []))
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData

            screen:        modelData
            color:         Colors.background
            exclusionMode: ExclusionMode.Auto

            anchors {
                top:    Config.navbarLocation !== "bottom"
                bottom: Config.navbarLocation !== "top"
                left:   Config.navbarLocation !== "right"
                right:  Config.navbarLocation !== "left"
            }

            implicitHeight: root.isHorizontal ? root.barSize : 0
            implicitWidth:  root.isHorizontal ? 0            : root.barSize

            // ── Horizontal ────────────────────────────────────────────────
            SlotLayout {
                isHorizontal: root.isHorizontal
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutLeft
                visible:      root.isHorizontal
                anchors.left:           parent.left
                anchors.leftMargin:     12
                anchors.verticalCenter: parent.verticalCenter
            }

            SlotLayout {
                isHorizontal: root.isHorizontal
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutCenter
                visible:      root.isHorizontal
                anchors.centerIn: parent
            }

            SlotLayout {
                isHorizontal: root.isHorizontal
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutRight
                visible:      root.isHorizontal
                anchors.right:          parent.right
                anchors.rightMargin:    12
                anchors.verticalCenter: parent.verticalCenter
            }

            // ── Vertical ──────────────────────────────────────────────────
            SlotLayout {
                isHorizontal: false
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutLeft
                visible:      !root.isHorizontal
                anchors.top:              parent.top
                anchors.topMargin:        12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SlotLayout {
                isHorizontal: false
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutCenter
                visible:      !root.isHorizontal
                anchors.centerIn: parent
            }

            SlotLayout {
                isHorizontal: false
                barSize:      root.barSize
                moduleSize:   root.moduleSize
                barFont:      root.barFont
                modules:      root.layoutRight
                visible:      !root.isHorizontal
                anchors.bottom:           parent.bottom
                anchors.bottomMargin:     12
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
