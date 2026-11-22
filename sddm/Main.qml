import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "theme"
import "components"

Item {
    id: root

    width: Screen.width
    height: Screen.height

    readonly property real scaleFactor: Screen.height / 1080

    // Press Escape to exit test mode instantly
    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }

    // Base background gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: AetherTheme.bgDark }
            GradientStop { position: 0.5; color: AetherTheme.bgSurface }
            GradientStop { position: 1.0; color: AetherTheme.bgDark }
        }
    }

    // Ambient decorative glow
    Rectangle {
        width: Math.round(650 * root.scaleFactor)
        height: width
        radius: width / 2
        anchors.centerIn: parent
        color: AetherTheme.accentViolet
        opacity: 0.055
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.round(AetherTheme.panelWidth * root.scaleFactor)
        spacing: Math.round(16 * root.scaleFactor)

        Clock {
            scaleFactor: root.scaleFactor
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.preferredHeight: Math.round(12 * root.scaleFactor)
        }

        // Centered Login Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(290 * root.scaleFactor)
            radius: Math.round(AetherTheme.radiusLarge * root.scaleFactor)
            color: AetherTheme.bgSurfaceTranslucent
            border.color: AetherTheme.borderGlow
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(AetherTheme.panelPadding * root.scaleFactor)
                spacing: Math.round(14 * root.scaleFactor)

                Text {
                    text: "Welcome back"
                    color: AetherTheme.textPrimary
                    font.family: AetherTheme.fontFamily
                    font.pixelSize: Math.round(AetherTheme.fontSizeHeader * root.scaleFactor)
                    font.weight: Font.Medium
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Enter your credentials to continue"
                    color: AetherTheme.textSecondary
                    font.family: AetherTheme.fontFamily
                    font.pixelSize: Math.round(AetherTheme.fontSizeCaption * root.scaleFactor)
                    Layout.alignment: Qt.AlignHCenter
                }

                UsernameField {
                    id: usernameInput
                    scaleFactor: root.scaleFactor
                    Layout.fillWidth: true
                    KeyNavigation.tab: passwordInput
                }

                PasswordField {
                    id: passwordInput
                    scaleFactor: root.scaleFactor
                    Layout.fillWidth: true
                    KeyNavigation.backtab: usernameInput
                }

                LoginButton {
                    scaleFactor: root.scaleFactor
                    Layout.fillWidth: true
                    onClicked: {
                        console.log("Login trigger for user:", usernameInput.text)
                    }
                }
            }
        }

        Text {
            text: "A quiet space between worlds"
            color: AetherTheme.textMuted
            font.family: AetherTheme.fontFamily
            font.pixelSize: Math.round(AetherTheme.fontSizeFootnote * root.scaleFactor)
            font.letterSpacing: AetherTheme.letterSpacingSubtle * root.scaleFactor
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Math.round(6 * root.scaleFactor)
        }
    }
}