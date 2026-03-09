// globals/Config.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string configPath: Quickshell.env("HOME") + "/.config/quickshell/config.json"
    readonly property string tmpPath:    Quickshell.env("HOME") + "/.config/quickshell/.config.json.tmp"

    property string navbarLocation: "top"
    property bool   enableBorders:  true
    property string activeLayout:   "default"

    readonly property bool isHorizontal: navbarLocation === "top" || navbarLocation === "bottom"

    FileView {
        path: root.configPath
        adapter: JsonAdapter {
            property string navbarLocation: "top"
            property bool   enableBorders:  true
            property string activeLayout:   "default"

            onNavbarLocationChanged: root.navbarLocation = navbarLocation
            onEnableBordersChanged:  root.enableBorders  = enableBorders
            onActiveLayoutChanged:   root.activeLayout   = activeLayout
        }
    }

    function saveSetting(key, value) {
        if (key === "navbarLocation") root.navbarLocation = value
        if (key === "enableBorders")  root.enableBorders  = value
        if (key === "activeLayout")   root.activeLayout   = value

        let fileData = {
            navbarLocation: root.navbarLocation,
            enableBorders:  root.enableBorders,
            activeLayout:   root.activeLayout,
        }

        let jsonString = JSON.stringify(fileData, null, 2)
        Quickshell.execDetached({
            command: ["sh", "-c",
                `mkdir -p ~/.config/quickshell && echo '${jsonString}' > ${root.tmpPath} && mv ${root.tmpPath} ${root.configPath}`]
        })
    }
}
