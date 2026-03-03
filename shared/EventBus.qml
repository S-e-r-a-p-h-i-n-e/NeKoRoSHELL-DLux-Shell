// quickshell/shared/EventBus.qml
pragma Singleton

import QtQuick

QtObject {
    signal toggleSettingsPanel()
    signal changeLocation(string newLocation)
    signal toggleBorders(bool state)
}