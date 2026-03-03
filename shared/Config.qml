// quickshell/shared/Config.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string configPath: Quickshell.env("HOME") + "/.config/quickshell/config.json"

    property string navbarLocation: "top"
    property bool enableBorders: true

    FileView {
        id: configFile
        path: root.configPath

        adapter: JsonAdapter {
            id: configAdapter
            
            property JsonObject config: JsonObject {}
            
            onConfigChanged: {
                if (!config) return; 
                
                if (config.navbarLocation !== undefined) 
                    root.navbarLocation = config.navbarLocation;
                    
                if (config.enableBorders !== undefined) 
                    root.enableBorders = config.enableBorders;
            }
        }
    }

    function saveSetting(key, value) {
        if (key === "navbarLocation") root.navbarLocation = value;
        if (key === "enableBorders") root.enableBorders = value;
        if (key === "visualizerEnabled") root.visualizerEnabled = value;

        let currentConfig = {
            navbarLocation: root.navbarLocation,
            enableBorders: root.enableBorders,
            visualizerEnabled: root.visualizerEnabled
        };

        let fileData = {
            config: currentConfig
        };

        let jsonString = JSON.stringify(fileData, null, 2);

        Quickshell.execDetached({
            command: ["sh", "-c", `mkdir -p ~/.config/quickshell && echo '${jsonString}' > ${root.configPath}`]
        });
    }
}