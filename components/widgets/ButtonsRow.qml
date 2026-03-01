import QtQuick
import ".."
import "../../shared"

Row {
    id: root
    spacing: 13

    anchors {
        verticalCenter: parent.verticalCenter
    }

    Button {
        id: notif
        labelText: "󰂚"
        labelFont: navbar.font
        buttonSize: navbar.barSize / 1.65
        buttonColor: Colors.color7
    }

    Button {
        id: settings
        labelText: ""
        labelFont: navbar.font
        buttonSize: navbar.barSize / 1.65
        buttonColor: Colors.color7
    }

    Button {
        id: power
        labelText: "⏻"
        labelFont: navbar.font
        buttonSize: navbar.barSize / 1.65
        buttonColor: Colors.color7
    }
}