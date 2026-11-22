import QtQuick
import QtQuick.Controls
import "../theme"

Button {
    id: root

    property real scaleFactor: 1.0
    property bool busy: false

    text: "CONTINUE"

    contentItem: Item {
        implicitHeight: Math.round(AetherTheme.controlHeight * root.scaleFactor)

        Row {
            anchors.centerIn: parent
            spacing: Math.round(8 * root.scaleFactor)

            Text {
                text: root.text
                color: root.down ? AetherTheme.accentLavender : "#FFFFFF"
                font.family: AetherTheme.fontFamily
                font.pixelSize: Math.round(AetherTheme.fontSizeBody * root.scaleFactor)
                font.bold: true
                font.letterSpacing: AetherTheme.letterSpacingNormal * root.scaleFactor
                anchors.verticalCenter: parent.verticalCenter
            }

            BusyIndicator {
                running: root.busy
                visible: root.busy
                width: Math.round(18 * root.scaleFactor)
                height: Math.round(18 * root.scaleFactor)
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    background: Rectangle {
        implicitHeight: Math.round(AetherTheme.controlHeight * root.scaleFactor)
        radius: Math.round(AetherTheme.radiusSmall * root.scaleFactor)
        color: root.down ? AetherTheme.accentLavender :
               root.hovered ? AetherTheme.accentVioletHover : AetherTheme.accentViolet
        border.color: root.hovered ? AetherTheme.accentLavender : "transparent"
        border.width: 1

        Behavior on color {
            ColorAnimation { duration: AetherTheme.animFast }
        }
        Behavior on border.color {
            ColorAnimation { duration: AetherTheme.animFast }
        }
    }
}