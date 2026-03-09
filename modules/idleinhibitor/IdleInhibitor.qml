// modules/idleinhibitor/IdleInhibitor.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.globals

QtObject {
    property bool inhibited: false
    function toggle() { inhibited = !inhibited }
    readonly property string icon: inhibited ? "" : ""
    property var _proc: Process {
        running: inhibited
        command: ["/bin/bash", "-c",
            "wayland-idle-inhibitor 2>/dev/null || " +
            "systemd-inhibit --what=idle --who=quickshell --why=UserToggle --mode=block sleep infinity"]
    }
}