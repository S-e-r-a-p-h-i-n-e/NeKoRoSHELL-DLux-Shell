// modules/systeminfo/SystemInfo.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.globals

QtObject {
    property int    cpuPercent: 0
    property int    memPercent: 0
    property string gpuText:    ""
    property int _prevIdle:  0
    property int _prevTotal: 0
    function openMonitor() {
        Quickshell.execDetached({ command: ["/bin/bash", "-l", "-c", "kitty -e btop"] })
    }
    property var _sysProc: Process {
        id: sysProc
        command: ["/bin/bash", "-c", "cat /proc/stat | head -1; echo '---'; cat /proc/meminfo"]
        property string _buf: ""
        stdout: SplitParser { onRead: (l) => { sysProc._buf += l + "\n" } }
        onExited: {
            let sections = _buf.split("---\n")
            if (sections[0]) {
                let parts = sections[0].trim().split(/\s+/).slice(1).map(Number)
                let idle  = parts[3] + (parts[4] || 0)
                let total = parts.reduce((a, b) => a + b, 0)
                let dI = idle - SystemInfo._prevIdle, dT = total - SystemInfo._prevTotal
                SystemInfo.cpuPercent = dT > 0 ? Math.round((1 - dI / dT) * 100) : 0
                SystemInfo._prevIdle = idle; SystemInfo._prevTotal = total
            }
            if (sections[1]) {
                let lines = sections[1].split("\n")
                let val = (k) => { let l = lines.find(l => l.startsWith(k)); return l ? parseInt(l.split(/\s+/)[1]) : 0 }
                let tot = val("MemTotal:"), free = val("MemFree:"), buf = val("Buffers:"), cac = val("Cached:")
                SystemInfo.memPercent = tot > 0 ? Math.round((tot - free - buf - cac) / tot * 100) : 0
            }
            _buf = ""
        }
    }
    property var _gpuProc: Process {
        id: gpuProc
        command: ["/bin/bash", "-l", "-c", "gpu-temp.sh 2>/dev/null"]
        property string _buf: ""
        stdout: SplitParser { onRead: (l) => { gpuProc._buf = l.trim() } }
        onExited: { SystemInfo.gpuText = _buf; _buf = "" }
    }
    property var _sysTimer: Timer { interval: 1000; running: true; repeat: true; onTriggered: sysProc.running = true }
    property var _gpuTimer: Timer { interval: 1000; running: true; repeat: true; onTriggered: gpuProc.running = true }
    Component.onCompleted: { sysProc.running = true; gpuProc.running = true }
}