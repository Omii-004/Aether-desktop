import QtQuick
import QtQuick.Controls
import "../theme"

TextField {
    id: root

    property real scaleFactor: 1.0

    placeholderText: "Username"
    color: AetherTheme.textPrimary
    placeholderTextColor: AetherTheme.textPlaceholder
    font.family: AetherTheme.fontFamily
    font.pixelSize: Math.round(AetherTheme.fontSizeBody * root.scaleFactor)
    leftPadding: Math.round(16 * root.scaleFactor)
    rightPadding: Math.round(16 * root.scaleFactor)
    selectByMouse: true

    background: Rectangle {
        implicitHeight: Math.round(AetherTheme.controlHeight * root.scaleFactor)
        radius: Math.round(AetherTheme.radiusSmall * root.scaleFactor)
        color: root.activeFocus ? AetherTheme.bgCardHover : AetherTheme.bgCard
        border.color: root.activeFocus ? AetherTheme.borderFocused : AetherTheme.borderDefault
        border.width: 1

        Behavior on border.color {
            ColorAnimation { duration: AetherTheme.animFast }
        }
        Behavior on color {
            ColorAnimation { duration: AetherTheme.animFast }
        }
    }
}