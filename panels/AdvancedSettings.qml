// panels/AdvancedSettings.qml
import QtQuick
import Quickshell
import QtQuick.Controls
import qs.components
import qs.globals

Panel {
    id: advPanel

    panelWidth:  420
    panelHeight: 580

    Column {
        anchors.fill: parent
        spacing: 0

        // ── Header ────────────────────────────────────────────────────────
        Text {
            text:           "󰒓  Advanced Settings"
            color:          Colors.foreground
            font.family:    Style.barFont
            font.pixelSize: 18
            font.weight:    Font.ExtraBold
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding:  16
        }

        Rectangle { width: parent.width; height: 1; color: Colors.color8; opacity: 0.5 }

        // ── Scrollable fields ─────────────────────────────────────────────
        ScrollView {
            id: scroll
            width:  parent.width
            height: parent.height - 18 - 16 - 1  // minus header + divider
            clip:   true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius:        2
                    color:         Colors.color7
                    opacity:       0.5
                }
            }

            Column {
                width:   scroll.width
                spacing: 0
                topPadding: 12

                // ── Bar ───────────────────────────────────────────────────
                StyleSection { label: "Bar" }

                StyleField {
                    label:        "Bar Size"
                    value:        Style.barSize
                    onCommitted:  (v) => Style.saveSetting("barSize", v)
                }
                StyleField {
                    label:        "Module Size"
                    value:        Style.moduleSize
                    onCommitted:  (v) => Style.saveSetting("moduleSize", v)
                }
                StyleField {
                    label:        "Bar Padding"
                    value:        Style.barPadding
                    onCommitted:  (v) => Style.saveSetting("barPadding", v)
                }
                StyleField {
                    label:        "Bar Font"
                    value:        Style.barFont
                    isText:       true
                    onCommitted:  (v) => Style.saveSetting("barFont", v)
                }

                StyleSection { label: "Slots" }

                StyleField {
                    label:        "Slot Spacing"
                    value:        Style.slotSpacing
                    onCommitted:  (v) => Style.saveSetting("slotSpacing", v)
                }

                StyleSection { label: "Pills" }

                StyleField {
                    label:        "Pill Padding"
                    value:        Style.pillPadding
                    onCommitted:  (v) => Style.saveSetting("pillPadding", v)
                }
                StyleField {
                    label:        "Pill Spacing"
                    value:        Style.pillSpacing
                    onCommitted:  (v) => Style.saveSetting("pillSpacing", v)
                }
                StyleField {
                    label:        "Pill Opacity"
                    value:        Style.pillOpacity
                    isDecimal:    true
                    onCommitted:  (v) => Style.saveSetting("pillOpacity", v)
                }

                StyleSection { label: "Chips" }

                StyleField {
                    label:        "Chip Spacing"
                    value:        Style.chipSpacing
                    onCommitted:  (v) => Style.saveSetting("chipSpacing", v)
                }
                StyleField {
                    label:        "Chip Inner Spacing"
                    value:        Style.chipInnerSpacing
                    onCommitted:  (v) => Style.saveSetting("chipInnerSpacing", v)
                }

                StyleSection { label: "Borders" }

                StyleField {
                    label:        "Border Width"
                    value:        Style.borderWidth
                    onCommitted:  (v) => Style.saveSetting("borderWidth", v)
                }
                StyleField {
                    label:        "Corner Radius"
                    value:        Style.cornerRadius
                    onCommitted:  (v) => Style.saveSetting("cornerRadius", v)
                }

                Item { width: 1; height: 12 }
            }
        }
    }

    // ── Section header ────────────────────────────────────────────────────
    component StyleSection: Item {
        property string label: ""
        width:  parent.width
        height: 32

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            anchors.leftMargin:     16
            text:           label.toUpperCase()
            color:          Colors.color8
            font.family:    Style.barFont
            font.pixelSize: 10
            font.weight:    Font.ExtraBold
            font.letterSpacing: 1.5
        }

        Rectangle {
            anchors.bottom:      parent.bottom
            anchors.left:        parent.left
            anchors.right:       parent.right
            anchors.leftMargin:  16
            anchors.rightMargin: 16
            height: 1
            color:  Colors.color8
            opacity: 0.3
        }
    }

    // ── Individual field ──────────────────────────────────────────────────
    component StyleField: Item {
        id: field
        property string label:     ""
        property var    value:     0
        property bool   isText:    false   // string input instead of number
        property bool   isDecimal: false   // allow decimals (e.g. opacity)

        signal committed(var newValue)

        width:  parent.width
        height: 52

        Text {
            id: fieldLabel
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            anchors.leftMargin:     16
            text:           field.label
            color:          Colors.foreground
            font.family:    Style.barFont
            font.pixelSize: 13
            width:          160
            elide:          Text.ElideRight
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:          parent.right
            anchors.rightMargin:    16
            width:  120
            height: 32
            radius: 8
            color:  Colors.color0

            TextInput {
                id: input
                anchors.fill:         parent
                anchors.leftMargin:   10
                anchors.rightMargin:  10
                anchors.topMargin:    6
                anchors.bottomMargin: 6

                text:              field.isText ? String(field.value) : String(field.value)
                color:             Colors.foreground
                font.family:       Style.barFont
                font.pixelSize:    13
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse:     true
                clip:              true

                validator: field.isText ? null : field.isDecimal ? decimalValidator : intValidator

                DoubleValidator { id: decimalValidator; bottom: 0; top: 1;   decimals: 2 }
                IntValidator    { id: intValidator;     bottom: 0; top: 999              }

                Keys.onReturnPressed: commit()
                Keys.onEnterPressed:  commit()
                onEditingFinished:    commit()

                function commit() {
                    if (field.isText) {
                        field.committed(text)
                    } else if (field.isDecimal) {
                        let v = parseFloat(text)
                        if (!isNaN(v)) field.committed(v)
                        else text = String(field.value)
                    } else {
                        let v = parseInt(text)
                        if (!isNaN(v)) field.committed(v)
                        else text = String(field.value)
                    }
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.leftMargin:  16
            anchors.rightMargin: 16
            height: 1
            color:  Colors.color8
            opacity: 0.15
        }
    }
}
