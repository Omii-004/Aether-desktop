import QtQuick
import "../theme"

Rectangle {
    id: root

    property real scaleFactor: 1.0
    property string iconText: ""
    property string tooltipText: ""
    signal clicked()

    width: Math.round(38 * root.scaleFactor)
    height: Math.round(38 * root.scaleFactor)
    radius: width / 2
    color: mouseArea.pressed ? AetherTheme.bgCardHover :
           mouseArea.containsMouse ? AetherTheme.bgCard : "transparent"
    border.color: mouseArea.containsMouse ? AetherTheme.borderFocused : "transparent"
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: AetherTheme.animFast }
    }
    Behavior on border.color {
        ColorAnimation { duration: AetherTheme.animFast }
    }

    Text {
        anchors.centerIn: parent
        text: root.iconText
        font.pixelSize: Math.round(16 * root.scaleFactor)
        color: mouseArea.containsMouse ? AetherTheme.textPrimary : AetherTheme.textSecondary
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}