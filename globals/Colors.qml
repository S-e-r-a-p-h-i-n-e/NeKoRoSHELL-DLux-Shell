// quickshell/shared/Colors.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property alias themeAdapter: themeAdapter

  readonly property color background: themeAdapter.special.background
  readonly property color foreground: themeAdapter.special.foreground
  readonly property color cursor: themeAdapter.special.cursor

  readonly property color color0: themeAdapter.colors.color0
  readonly property color color1: themeAdapter.colors.color1
  readonly property color color2: themeAdapter.colors.color2
  readonly property color color3: themeAdapter.colors.color3
  readonly property color color4: themeAdapter.colors.color4
  readonly property color color5: themeAdapter.colors.color5
  readonly property color color6: themeAdapter.colors.color6
  readonly property color color7: themeAdapter.colors.color7
  readonly property color color8: themeAdapter.colors.color8
  readonly property color color9: themeAdapter.colors.color9
  readonly property color color10: themeAdapter.colors.color10
  readonly property color color11: themeAdapter.colors.color11
  readonly property color color12: themeAdapter.colors.color12
  readonly property color color13: themeAdapter.colors.color13
  readonly property color color14: themeAdapter.colors.color14
  readonly property color color15: themeAdapter.colors.color15

  FileView {
    id: themeFile
    adapter: JsonAdapter {
      id: themeAdapter

      property JsonObject special: JsonObject {
        property color background: "#1E1E23"
        property color foreground: "#F6CBDB"
      }

      property JsonObject colors: JsonObject {
        property color color0: "#45454A"
        property color color1: "#46293F"
        property color color2: "#60334C"
        property color color3: "#793C58"
        property color color4: "#924665"
        property color color5: "#AB5071"
        property color color6: "#AB5071"
        property color color7: "#E9ACC3"
        property color color8: "#A37888"
        property color color9: "#5E3754"
        property color color10: "#804465"
        property color color11: "#A15076"
        property color color12: "#C25D86"
        property color color13: "#E46A97"
        property color color14: "#E46A97"
        property color color15: "#E9ACC3"
      }
    }
  }
}