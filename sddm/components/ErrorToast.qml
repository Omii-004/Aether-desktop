import QtQuick
import "../theme"

Rectangle {
    id: root

    property real scaleFactor: 1.0
    property string message: ""
    property bool isError: true

    visible: opacity > 0
    opacity: message.length > 0 ? 1.0 : 0.0
    implicitHeight: Math.round(36 * root.scaleFactor)
    radius: Math.round(AetherTheme.radiusSmall * root.scaleFactor)
    color: isError ? "#33FF5C7A" : "#3348D597"
    border.color: isError ? AetherTheme.statusError : AetherTheme.statusSuccess
    border.width: 1

    Behavior on opacity {
        NumberAnimation { duration: AetherTheme.animNormal }
    }

    Row {
        anchors.centerIn: parent
        spacing: Math.round(8 * root.scaleFactor)

        Text {
            text: root.isError ? "⚠" : "✓"
            color: root.isError ? AetherTheme.statusError : AetherTheme.statusSuccess
            font.pixelSize: Math.round(13 * root.scaleFactor)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.message
            color: AetherTheme.textPrimary
            font.family: AetherTheme.fontFamily
            font.pixelSize: Math.round(AetherTheme.fontSizeCaption * root.scaleFactor)
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}