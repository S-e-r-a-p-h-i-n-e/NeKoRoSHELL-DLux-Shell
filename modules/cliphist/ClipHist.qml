// modules/cliphist/ClipHist.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import qs.globals

QtObject {
    function open() {
        Quickshell.execDetached({ command: ["/bin/bash", "-l", "-c", "clipmgr.sh"] })
    }
}