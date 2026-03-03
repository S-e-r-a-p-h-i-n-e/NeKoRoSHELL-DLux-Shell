import Quickshell
import QtQuick
import qs.components
import qs.shared

Scope {
    id: root
    
    property real navbarSize: 40
    property real fontSize: 12
    property real borderWidth: 10
    property real cornerRadius: 20

    property bool isPanelOpen: false

    Connections {
        target: EventBus
        
        function onToggleSettingsPanel() {
            root.isPanelOpen = !root.isPanelOpen
        }
        
        function onChangeLocation(newLocation) {
            Config.saveSetting("navbarLocation", newLocation)
        }
        
        function onToggleBorders(state) {
            Config.saveSetting("enableBorders", state)
        }
    }

    ScreenBorder {
        enabled: Config.enableBorders 
        location: Config.navbarLocation
        borderColor: Colors.background
        borderWidth: root.borderWidth
        cornerRadius: root.cornerRadius

        Navbar {
            location: Config.navbarLocation
            barColor: Colors.background
            barSize: root.navbarSize
            fontSize: root.fontSize
        }
    }

    SettingsPanel {
        showPanel: root.isPanelOpen
        bordersEnabled: Config.enableBorders
    }
}