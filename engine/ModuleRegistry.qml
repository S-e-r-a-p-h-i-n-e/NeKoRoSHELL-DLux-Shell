// engine/ModuleRegistry.qml
pragma Singleton

import QtQuick
import Quickshell
import qs.modules.audio
import qs.modules.cava
import qs.modules.cliphist
import qs.modules.clock
import qs.modules.idleinhibitor
import qs.modules.layoutswitcher
import qs.modules.media
import qs.modules.network
import qs.modules.notifications
import qs.modules.power
import qs.modules.settings
import qs.modules.status
import qs.modules.systeminfo
import qs.modules.tray
import qs.modules.updates
import qs.modules.wallchange
import qs.modules.workspaces

QtObject {
    id: root

    function resolve(name) {
        switch (name) {
            case "audio":          return audioView
            case "cava":           return cavaView
            case "cliphist":       return clipHistView
            case "clock":          return clockView
            case "idleinhibitor":  return idleInhibitorView
            case "layoutswitcher": return layoutSwitcherView
            case "media":          return mediaView
            case "network":        return networkView
            case "notifications":  return notificationsView
            case "power":          return powerView
            case "settings":       return settingsView
            case "status":         return statusView
            case "battery":        return statusView   // alias
            case "backlight":      return statusView   // alias
            case "cpu":            return systemInfoView
            case "memory":         return systemInfoView
            case "systeminfo":     return systemInfoView
            case "tray":           return trayView
            case "updates":        return updatesView
            case "wallchange":     return wallChangeView
            case "workspaces":     return workspacesView
            default:
                console.warn("ModuleRegistry: unknown module '" + name + "'")
                return null
        }
    }

    property Component audioView:         AudioView         {}
    property Component cavaView:          CavaView          {}
    property Component clipHistView:      ClipHistView      {}
    property Component clockView:         ClockView         {}
    property Component idleInhibitorView: IdleInhibitorView {}
    property Component layoutSwitcherView: LayoutSwitcherView {}
    property Component mediaView:         MediaView         {}
    property Component networkView:       NetworkView       {}
    property Component notificationsView: NotificationsView {}
    property Component powerView:         PowerView         {}
    property Component settingsView:      SettingsView      {}
    property Component statusView:        StatusView        {}
    property Component systemInfoView:    SystemInfoView    {}
    property Component trayView:          TrayView          {}
    property Component updatesView:       UpdatesView       {}
    property Component wallChangeView:    WallChangeView    {}
    property Component workspacesView:    WorkspacesView    {}
}
