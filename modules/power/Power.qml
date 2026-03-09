// modules/power/Power.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell

QtObject {
    function open() {
        Quickshell.execDetached({ command: ["sh", "-c",
            "wlogout -b 5 -l ~/.config/wlogout/layout -C ~/.config/wlogout/style.css"] })
    }
}
