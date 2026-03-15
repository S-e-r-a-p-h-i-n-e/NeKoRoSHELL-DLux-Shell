// components/ScreenBorder.qml
// qmllint disable
import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.globals

Scope {
    id: border

    property bool   enabled:      true
    property string location
    property real   borderWidth
    property real   cornerRadius
    property color  borderColor

    // Fade the border color alpha so edges and corners animate in/out
    // smoothly rather than snapping when enableBorders is toggled.
    // animatedAlpha is tracked separately so PanelWindows can be hidden
    // once the fade completes — keeping them visible: true while transparent
    // would leave invisible windows consuming compositor exclusion zones.
    property real animatedAlpha: border.enabled ? 1.0 : 0.0
    Behavior on animatedAlpha { NumberAnimation { duration: Animations.normal; easing.type: Animations.easeInOut } }

    readonly property color animatedColor: Qt.rgba(
        borderColor.r,
        borderColor.g,
        borderColor.b,
        animatedAlpha * borderColor.a
    )

    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData
            property var currentScreen: modelData

            // ── straight edges ────────────────────────────────────────────
            PanelWindow {
                screen:         currentScreen
                anchors { top: true; left: true; right: true }
                implicitHeight: border.borderWidth
                color:          border.animatedColor
                visible:        border.animatedAlpha > 0 && border.location !== "top"
            }
            PanelWindow {
                screen:        currentScreen
                anchors { top: true; left: true; bottom: true }
                implicitWidth: border.borderWidth
                color:         border.animatedColor
                visible:       border.animatedAlpha > 0 && border.location !== "left"
            }
            PanelWindow {
                screen:         currentScreen
                anchors { bottom: true; left: true; right: true }
                implicitHeight: border.borderWidth
                color:          border.animatedColor
                visible:        border.animatedAlpha > 0 && border.location !== "bottom"
            }
            PanelWindow {
                screen:        currentScreen
                anchors { top: true; right: true; bottom: true }
                implicitWidth: border.borderWidth
                color:         border.animatedColor
                visible:       border.animatedAlpha > 0 && border.location !== "right"
            }

            // ── corners ───────────────────────────────────────────────────
            PanelWindow {
                screen: currentScreen
                anchors { top: true; left: true }
                implicitHeight: border.cornerRadius
                implicitWidth:  border.cornerRadius
                color:   "transparent"
                visible: border.animatedAlpha > 0
                Shape {
                    width: border.cornerRadius; height: border.cornerRadius
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath {
                        strokeWidth: 0; fillColor: border.animatedColor
                        startX: 0; startY: border.cornerRadius
                        PathArc  { x: border.cornerRadius; y: 0; radiusX: border.cornerRadius; radiusY: border.cornerRadius; direction: PathArc.Clockwise }
                        PathLine { x: 0; y: 0 }
                        PathLine { x: 0; y: border.cornerRadius }
                    }
                }
            }
            PanelWindow {
                screen: currentScreen
                anchors { top: true; right: true }
                implicitHeight: border.cornerRadius
                implicitWidth:  border.cornerRadius
                color:   "transparent"
                visible: border.animatedAlpha > 0
                Shape {
                    width: border.cornerRadius; height: border.cornerRadius
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath {
                        strokeWidth: 0; fillColor: border.animatedColor
                        startX: 0; startY: 0
                        PathArc  { x: border.cornerRadius; y: border.cornerRadius; radiusX: border.cornerRadius; radiusY: border.cornerRadius; direction: PathArc.Clockwise }
                        PathLine { x: border.cornerRadius; y: 0 }
                        PathLine { x: 0; y: 0 }
                    }
                }
            }
            PanelWindow {
                screen: currentScreen
                anchors { bottom: true; left: true }
                implicitHeight: border.cornerRadius
                implicitWidth:  border.cornerRadius
                color:   "transparent"
                visible: border.animatedAlpha > 0
                Shape {
                    width: border.cornerRadius; height: border.cornerRadius
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath {
                        strokeWidth: 0; fillColor: border.animatedColor
                        startX: border.cornerRadius; startY: border.cornerRadius
                        PathArc  { x: 0; y: 0; radiusX: border.cornerRadius; radiusY: border.cornerRadius; direction: PathArc.Clockwise }
                        PathLine { x: 0; y: border.cornerRadius }
                        PathLine { x: border.cornerRadius; y: border.cornerRadius }
                    }
                }
            }
            PanelWindow {
                screen: currentScreen
                anchors { bottom: true; right: true }
                implicitHeight: border.cornerRadius
                implicitWidth:  border.cornerRadius
                color:   "transparent"
                visible: border.animatedAlpha > 0
                Shape {
                    width: border.cornerRadius; height: border.cornerRadius
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath {
                        strokeWidth: 0; fillColor: border.animatedColor
                        startX: 0; startY: border.cornerRadius
                        PathLine { x: border.cornerRadius; y: border.cornerRadius }
                        PathLine { x: border.cornerRadius; y: 0 }
                        PathArc  { x: 0; y: border.cornerRadius; radiusX: border.cornerRadius; radiusY: border.cornerRadius; direction: PathArc.Clockwise }
                    }
                }
            }
        }
    }
}
