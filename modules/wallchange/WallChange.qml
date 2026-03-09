// modules/wallchange/WallChange.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import qs.globals

QtObject {
    function change() {
        Quickshell.execDetached({ command: ["/bin/bash", "-l", "-c", "wallchange.sh"] })
    }
}