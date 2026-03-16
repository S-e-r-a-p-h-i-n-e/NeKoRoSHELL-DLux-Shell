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
        // #CC is ~80% opacity. 1E1E2E is a neutral, deep slate.
        property color background: "#CC1E1E2E" 
        property color foreground: "#CAD3F5"
        property color cursor: "#F4DBD6"
      }

      property JsonObject colors: JsonObject {
        property color color0: "#494D64" // Black (Muted Slate)
        property color color1: "#ED8796" // Red
        property color color2: "#A6DA95" // Green
        property color color3: "#EED49F" // Yellow
        property color color4: "#8AADF4" // Blue
        property color color5: "#F5BDE6" // Magenta
        property color color6: "#8BD5CA" // Cyan
        property color color7: "#B8C0E0" // White
        property color color8: "#5B6078" // Bright Black
        property color color9: "#ED8796" // Bright Red
        property color color10: "#A6DA95" // Bright Green
        property color color11: "#EED49F" // Bright Yellow
        property color color12: "#8AADF4" // Bright Blue
        property color color13: "#F5BDE6" // Bright Magenta
        property color color14: "#8BD5CA" // Bright Cyan
        property color color15: "#A5ADCB" // Bright White
      }
    }
  }
}