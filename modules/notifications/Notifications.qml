// modules/notifications/Notifications.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell

QtObject {
    function open() { Quickshell.execDetached({ command: ["swaync-client", "-t"] }) }
}
