// modules/workspaces/WorkspacesView.qml — FRONTEND ONLY
import QtQuick
import qs.globals
import qs.modules.workspaces

Item {
    id: root

    property bool   isHorizontal: true
    property real   barThickness: 40
    property string barFont:      "JetBrainsMono Nerd Font"
    property bool   inPill:       false

    readonly property real baseSize: barThickness / 1.65
    readonly property int  maxIcons: 5

    property real dotSize:  20        // diameter of the circle
    property real iconSize: dotSize * 0.75  // size of the icon glyph inside
    // Max width the app dot list is allowed to show before clipping+scroll kicks in
    readonly property real maxListSize: (dotSize + 6) * maxIcons - 6

    implicitWidth:  isHorizontal ? (container.implicitWidth + 15) : barThickness
    implicitHeight: isHorizontal ? barThickness                   : (container.implicitHeight + 15)

    // Pill background spanning the whole workspace cluster
    Rectangle {
        visible: !root.inPill
        anchors.centerIn: parent
        width:  root.isHorizontal ? (container.implicitWidth + 15) : root.barThickness
        height: root.isHorizontal ? root.barThickness              : (container.implicitHeight + 15)
        radius: (root.isHorizontal ? height : width) / 2
        color:   Colors.color7
        opacity: 0.325
    }

    Grid {
        id: container
        anchors.centerIn: parent
        columns: root.isHorizontal ? 0 : 1
        rows:    root.isHorizontal ? 1 : 0
        spacing: 15

        Repeater {
            id: workspaceRepeater
            model: Workspaces.workspaces

            delegate: Item {
                id: wsDelegate
                required property var modelData
                required property int index

                // Total natural content size (uncapped)
                readonly property real naturalListSize: appList.count > 0
                    ? appList.count * (root.dotSize + 6) - 6
                    : root.dotSize
                // Actual displayed size — capped at maxListSize
                readonly property real clampedListSize: Math.min(naturalListSize, root.maxListSize)
                readonly property bool hasOverflow: appList.count > root.maxIcons

                implicitWidth:  root.isHorizontal
                    ? (emptyDot.visible ? root.dotSize : clampedListSize)
                    : root.dotSize
                implicitHeight: root.isHorizontal
                    ? root.dotSize
                    : (emptyDot.visible ? root.dotSize : clampedListSize)



                // Empty workspace dot
                Rectangle {
                    id: emptyDot
                    visible: appList.count === 0
                    anchors.centerIn: parent
                    height: root.dotSize
                    width:  height
                    radius: height / 2
                    color:  emptyWsArea.containsMouse
                        ? Colors.foreground
                        : (wsDelegate.modelData.focused ? Colors.color3 : Colors.color7)
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 1
                        text:           wsDelegate.modelData.focused ? "󰣇" : wsDelegate.modelData.name
                        color:          emptyWsArea.containsMouse
                            ? Colors.background
                            : (wsDelegate.modelData.focused ? Colors.background : Colors.foreground)
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.family:    root.barFont
                        font.pixelSize: root.iconSize
                        font.weight:    Font.ExtraBold
                    }

                    MouseArea {
                        id: emptyWsArea
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:    Workspaces.activate(wsDelegate.modelData)
                    }
                }

                // Scrollable app dot list
                ListView {
                    id: appList
                    visible: count > 0
                    anchors.centerIn: parent

                    // Size clamps to maxIcons worth of dots
                    width:  root.isHorizontal ? wsDelegate.clampedListSize : root.barThickness
                    height: root.isHorizontal ? root.barThickness          : wsDelegate.clampedListSize

                    orientation:      root.isHorizontal ? ListView.Horizontal : ListView.Vertical
                    spacing:          6
                    clip:             true
                    interactive:      false   // no touch/drag flick — wheel only
                    boundsBehavior:   Flickable.StopAtBounds
                    model:            wsDelegate.modelData.toplevels

                    // Smooth scroll state
                    property real scrollTarget: 0

                    // Wheel scrolls by one dot-width at a time, snapping
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        onWheel: (event) => {
                            let step = root.dotSize + 6
                            let maxScroll = Math.max(0,
                                appList.count * step - 6 - (root.isHorizontal ? appList.width : appList.height))
                            let delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                            appList.scrollTarget = Math.max(0, Math.min(maxScroll,
                                appList.scrollTarget + (delta > 0 ? -step : step)))
                            scrollAnim.restart()
                        }
                    }

                    SmoothedAnimation {
                        id: scrollAnim
                        target:   appList
                        property: root.isHorizontal ? "contentX" : "contentY"
                        to:       appList.scrollTarget
                        velocity: 400
                    }

                    delegate: Rectangle {
                        id: appDot
                        required property var  modelData
                        required property int  index

                        readonly property bool isFocused: modelData.activated && wsDelegate.modelData.focused

                        // Full bar height so the dot centers inside the pill
                        width:  root.isHorizontal ? root.dotSize     : root.barThickness
                        height: root.isHorizontal ? root.barThickness : root.dotSize
                        color:  "transparent"

                        Rectangle {
                            anchors.centerIn: parent
                            height: root.dotSize
                            width:  height
                            radius: height / 2
                            color:  appArea.containsMouse
                                ? Colors.foreground
                                : (appDot.isFocused ? Colors.color3 : Colors.color7)
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: 0.25
                                anchors.verticalCenterOffset:   1
                                text:           Workspaces.iconFor(appDot.modelData)
                                color:          appArea.containsMouse
                                    ? Colors.background
                                    : (appDot.isFocused ? Colors.color7 : Colors.color3)
                                Behavior on color { ColorAnimation { duration: 150 } }
                                font.family:    root.barFont
                                font.pixelSize: root.iconSize
                                font.weight:    Font.Bold
                            }
                        }

                        MouseArea {
                            id: appArea
                            anchors.fill: parent
                            cursorShape:  Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked:    Workspaces.focusWindow(appDot.modelData.address)
                        }
                    }
                }

                // Separator between workspaces
                Rectangle {
                    visible: wsDelegate.index < (workspaceRepeater.count - 1)
                    width:   root.isHorizontal ? 2                   : root.dotSize * 0.5
                    height:  root.isHorizontal ? root.dotSize * 0.5 : 2
                    radius:  1
                    color:   Colors.foreground
                    opacity: 0.15
                    x: root.isHorizontal
                        ? wsDelegate.width + (15 - width) / 2
                        : (wsDelegate.width - width) / 2
                    y: root.isHorizontal
                        ? (wsDelegate.height - height) / 2
                        : wsDelegate.height + (15 - height) / 2
                }
            }
        }
    }
}
