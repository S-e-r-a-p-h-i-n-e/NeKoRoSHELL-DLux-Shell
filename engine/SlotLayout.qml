// engine/SlotLayout.qml
pragma ComponentBehavior: Bound

import QtQuick
import qs.globals

Item {
    id: root

    property bool   isHorizontal: true
    property real   barSize:      50   // controls slot implicit size for centering
    property real   moduleSize:   32   // passed to modules and pills
    property string barFont:      "JetBrainsMono Nerd Font"
    property var    modules:      []

    implicitWidth:  isHorizontal ? row.implicitWidth  : barSize
    implicitHeight: isHorizontal ? barSize            : col.implicitHeight

    Row {
        id: row
        visible:          root.isHorizontal
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.isHorizontal ? root.modules : []
            delegate: Item {
                id: hEntry
                required property var modelData
                readonly property bool isGroup: typeof modelData !== "string"

                implicitWidth:  isGroup ? pill.implicitWidth  : mod.implicitWidth
                implicitHeight: isGroup ? pill.implicitHeight : mod.implicitHeight
                width:  implicitWidth
                height: implicitHeight

                PillGroup {
                    id: pill
                    visible:      hEntry.isGroup
                    isHorizontal: root.isHorizontal
                    barSize:      root.barSize
                    moduleSize:   root.moduleSize
                    barFont:      root.barFont
                    modules:      hEntry.isGroup ? hEntry.modelData : []
                }

                Loader {
                    id: mod
                    visible:         !hEntry.isGroup
                    sourceComponent: !hEntry.isGroup ? ModuleRegistry.resolve(hEntry.modelData) : null
                    Binding { when: mod.status === Loader.Ready; target: mod.item; property: "isHorizontal"; value: root.isHorizontal }
                    Binding { when: mod.status === Loader.Ready; target: mod.item; property: "barThickness";  value: root.moduleSize }
                    Binding { when: mod.status === Loader.Ready; target: mod.item; property: "barFont";       value: root.barFont }
                    Binding { when: mod.status === Loader.Ready; target: mod.item; property: "inPill";        value: false }
                }
            }
        }
    }

    Column {
        id: col
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.isHorizontal ? [] : root.modules
            delegate: Item {
                id: vEntry
                required property var modelData
                readonly property bool isGroup: typeof modelData !== "string"

                implicitWidth:  isGroup ? vpill.implicitWidth  : vmod.implicitWidth
                implicitHeight: isGroup ? vpill.implicitHeight : vmod.implicitHeight
                width:  implicitWidth
                height: implicitHeight

                PillGroup {
                    id: vpill
                    visible:      vEntry.isGroup
                    isHorizontal: root.isHorizontal
                    barSize:      root.barSize
                    moduleSize:   root.moduleSize
                    barFont:      root.barFont
                    modules:      vEntry.isGroup ? vEntry.modelData : []
                }

                Loader {
                    id: vmod
                    visible:         !vEntry.isGroup
                    sourceComponent: !vEntry.isGroup ? ModuleRegistry.resolve(vEntry.modelData) : null
                    Binding { when: vmod.status === Loader.Ready; target: vmod.item; property: "isHorizontal"; value: root.isHorizontal }
                    Binding { when: vmod.status === Loader.Ready; target: vmod.item; property: "barThickness";  value: root.moduleSize }
                    Binding { when: vmod.status === Loader.Ready; target: vmod.item; property: "barFont";       value: root.barFont }
                    Binding { when: vmod.status === Loader.Ready; target: vmod.item; property: "inPill";        value: false }
                }
            }
        }
    }
}
