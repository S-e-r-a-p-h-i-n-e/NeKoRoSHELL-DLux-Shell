// modules/layoutswitcher/LayoutSwitcher.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import qs.globals

QtObject {
    function open() { EventBus.togglePanel("theming") }
}