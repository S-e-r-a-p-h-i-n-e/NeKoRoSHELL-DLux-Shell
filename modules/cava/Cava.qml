// modules/cava/Cava.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.globals

QtObject {
    property string bars:     "▁▁▁▁▁▁▁▁"
    property bool   present:  false
    property var _check: Process {
        id: checkProc
        command: ["/bin/bash", "-l", "-c", "command -v cava.sh >/dev/null 2>&1 && echo yes || echo no"]
        running: true
        stdout: SplitParser {
            onRead: (l) => { if (l.trim() === "yes") { Cava.present = true; cavaProc.running = true } }
        }
    }
    property var _proc: Process {
        id: cavaProc
        command: ["/bin/bash", "-l", "-c", "cava.sh"]
        running: false
        stdout: SplitParser {
            onRead: (l) => { let t = l.trim(); if (t) Cava.bars = t }
        }
        onExited: { if (Cava.present) Qt.callLater(() => { cavaProc.running = true }) }
    }
}