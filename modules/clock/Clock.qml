// modules/clock/Clock.qml  — BACKEND ONLY
pragma Singleton

import QtQuick
import qs.globals

QtObject {
    readonly property string time: Time.time
    readonly property string date: Time.date
}