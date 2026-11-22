import QtQuick
import QtQuick.Controls
import "../theme"

TextField {
    id: root

    property real scaleFactor: 1.0

    placeholderText: "Password"
    echoMode: TextInput.Password
    color: AetherTheme.textPrimary
    placeholderTextColor: AetherTheme.textPlaceholder
    font.family: AetherTheme.fontFamily
    font.pixelSize: Math.round(AetherTheme.fontSizeBody * root.scaleFactor)
    leftPadding: Math.round(16 * root.scaleFactor)
    rightPadding: Math.round(44 * root.scaleFactor)
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

    Text {
        anchors.right: parent.right
        anchors.rightMargin: Math.round(14 * root.scaleFactor)
        anchors.verticalCenter: parent.verticalCenter
        text: root.echoMode === TextInput.Password ? "👁" : "✓"
        font.pixelSize: Math.round(14 * root.scaleFactor)
        color: revealArea.containsMouse ? AetherTheme.accentLavender : AetherTheme.textMuted
        opacity: root.text.length > 0 ? 0.85 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: AetherTheme.animFast }
        }

        MouseArea {
            id: revealArea
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.echoMode = (root.echoMode === TextInput.Password)
                    ? TextInput.Normal
                    : TextInput.Password
            }
        }
    }
}