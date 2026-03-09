// engine/PillGroup.qml
pragma ComponentBehavior: Bound

import QtQuick
import qs.globals

Item {
    id: root

    property bool   isHorizontal: true
    property real   barSize:      50   // for implicit size reporting up the chain
    property real   moduleSize:   32   // actual pill/module thickness
    property string barFont:      "JetBrainsMono Nerd Font"
    property var    modules:      []

    implicitWidth:  isHorizontal ? pillRow.implicitWidth + 16 : moduleSize
    implicitHeight: isHorizontal ? moduleSize                 : pillCol.implicitHeight + 16

    Rectangle {
        anchors.fill: parent
        radius:       Math.min(width, height) / 2
        color:        Colors.color0
        opacity:      0.6
    }

    Row {
        id: pillRow
        visible:          root.isHorizontal
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: root.isHorizontal ? root.modules : []
            delegate: Loader {
                id: phLoader
                required property string modelData
                sourceComponent: ModuleRegistry.resolve(modelData)
                Binding { when: phLoader.status === Loader.Ready; target: phLoader.item; property: "isHorizontal"; value: root.isHorizontal }
                Binding { when: phLoader.status === Loader.Ready; target: phLoader.item; property: "barThickness";  value: root.moduleSize }
                Binding { when: phLoader.status === Loader.Ready; target: phLoader.item; property: "barFont";       value: root.barFont }
                Binding { when: phLoader.status === Loader.Ready; target: phLoader.item; property: "inPill";        value: true }
            }
        }
    }

    Column {
        id: pillCol
        visible:          !root.isHorizontal
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: root.isHorizontal ? [] : root.modules
            delegate: Loader {
                id: pvLoader
                required property string modelData
                sourceComponent: ModuleRegistry.resolve(modelData)
                Binding { when: pvLoader.status === Loader.Ready; target: pvLoader.item; property: "isHorizontal"; value: root.isHorizontal }
                Binding { when: pvLoader.status === Loader.Ready; target: pvLoader.item; property: "barThickness";  value: root.moduleSize }
                Binding { when: pvLoader.status === Loader.Ready; target: pvLoader.item; property: "barFont";       value: root.barFont }
                Binding { when: pvLoader.status === Loader.Ready; target: pvLoader.item; property: "inPill";        value: true }
            }
        }
    }
}
