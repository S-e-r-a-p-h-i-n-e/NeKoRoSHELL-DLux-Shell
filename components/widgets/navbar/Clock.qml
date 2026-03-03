// quickshell/components/widgets/navbar/Clock.qml
import QtQuick
import qs.shared

Item {
    id: root
    
    property string location: "top"
    property alias clockFont: label.font.family
    property alias clockSize: label.font.pixelSize

    readonly property bool isSide: !navbar.isHorizontal

    implicitWidth: isSide ? (label.implicitHeight + 30) : (label.implicitWidth + 30)
    implicitHeight: isSide ? (label.implicitWidth + 30) : (label.implicitHeight + 30)

    Rectangle {
        id: pill
        anchors.centerIn: parent
        
        readonly property real thickness: (root.isSide ? parent.parent.width : parent.parent.height) / 1.65
        readonly property real length: label.implicitWidth + 30

        width: root.isSide ? thickness : length
        height: root.isSide ? length : thickness
        radius: (root.isSide ? width : height) / 2

        color: Colors.color7

        Text {
            id: label
            anchors.centerIn: parent
            rotation: root.location === "left" ? -90 : (root.location === "right" ? 90 : 0)
            
            color: Colors.background 
            text: Time.time
            font.weight: Font.ExtraBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
