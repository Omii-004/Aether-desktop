import QtQuick
import "../theme"

Rectangle {
    id: root

    property real scaleFactor: 1.0
    property int selectedIndex: (typeof sessionModel !== "undefined" && sessionModel) ? sessionModel.lastIndex : 0

    height: Math.round(34 * root.scaleFactor)
    width: sessionRow.implicitWidth + Math.round(24 * root.scaleFactor)
    radius: Math.round(AetherTheme.radiusSmall * root.scaleFactor)
    color: mouseArea.containsMouse ? AetherTheme.bgCardHover : AetherTheme.bgCard
    border.color: mouseArea.containsMouse ? AetherTheme.borderFocused : AetherTheme.borderDefault
    border.width: 1

    Behavior on color { ColorAnimation { duration: AetherTheme.animFast } }
    Behavior on border.color { ColorAnimation { duration: AetherTheme.animFast } }

    Row {
        id: sessionRow
        anchors.centerIn: parent
        spacing: Math.round(8 * root.scaleFactor)

        Text {
            text: "❖"
            font.pixelSize: Math.round(13 * root.scaleFactor)
            color: AetherTheme.accentLavender
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: {
                if (typeof sessionModel !== "undefined" && sessionModel && sessionModel.rowCount() > 0) {
                    var idx = Math.max(0, Math.min(root.selectedIndex, sessionModel.rowCount() - 1))
                    return sessionModel.data(sessionModel.index(idx, 0), Qt.UserRole + 1) || "Hyprland"
                }
                return "Hyprland (Wayland)"
            }
            font.family: AetherTheme.fontFamily
            font.pixelSize: Math.round(AetherTheme.fontSizeCaption * root.scaleFactor)
            color: AetherTheme.textPrimary
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (typeof sessionModel !== "undefined" && sessionModel && sessionModel.rowCount() > 1) {
                root.selectedIndex = (root.selectedIndex + 1) % sessionModel.rowCount()
            }
        }
    }
}