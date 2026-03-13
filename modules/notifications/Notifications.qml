// modules/notifications/Notifications.qml  — BACKEND + MODULE DESCRIPTOR
pragma Singleton

import QtQuick
import Quickshell
import qs.globals

QtObject {
    readonly property string moduleType: "static"

    readonly property var item: ({
        icon:      "󰂚",
        onClicked: function() { Notifications.open() }
    })

    function open() { Quickshell.execDetached({ command: ["swaync-client", "-t"] }) }
}
