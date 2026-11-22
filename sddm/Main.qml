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

    // SDDM Authentication signals
    Connections {
        target: (typeof sddm !== "undefined") ? sddm : null

        function onLoginSucceeded() {
            loginBtn.busy = false
            errorToast.isError = false
            errorToast.message = "Welcome back!"
        }

        function onLoginFailed() {
            loginBtn.busy = false
            passwordInput.text = ""
            errorToast.isError = true
            errorToast.message = "Authentication failed. Please try again."
            passwordInput.forceActiveFocus()
        }

        function onInformationMessage(message) {
            errorToast.isError = false
            errorToast.message = message
        }
    }

    function handleLogin() {
        errorToast.message = ""
        if (usernameInput.text.trim().length === 0) {
            errorToast.isError = true
            errorToast.message = "Please enter your username"
            usernameInput.forceActiveFocus()
            return
        }
        if (passwordInput.text.length === 0) {
            errorToast.isError = true
            errorToast.message = "Please enter your password"
            passwordInput.forceActiveFocus()
            return
        }

        loginBtn.busy = true

        if (typeof sddm !== "undefined") {
            sddm.login(usernameInput.text.trim(), passwordInput.text, sessionSelector.selectedIndex)
        } else {
            // Simulated response in test mode
            testTimer.restart()
        }
    }

    Timer {
        id: testTimer
        interval: 600
        onTriggered: {
            loginBtn.busy = false
            errorToast.isError = false
            errorToast.message = "Test Mode: Authentication triggered for " + usernameInput.text
        }
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

    // Central Interface
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.round(AetherTheme.panelWidth * root.scaleFactor)
        spacing: Math.round(14 * root.scaleFactor)

        Clock {
            scaleFactor: root.scaleFactor
            Layout.alignment: Qt.AlignHCenter
        }

        ErrorToast {
            id: errorToast
            scaleFactor: root.scaleFactor
            Layout.fillWidth: true
        }

        // Login Card
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
                    text: (typeof userModel !== "undefined" && userModel && userModel.lastUser) ? userModel.lastUser : ""
                    onAccepted: passwordInput.forceActiveFocus()
                }

                PasswordField {
                    id: passwordInput
                    scaleFactor: root.scaleFactor
                    Layout.fillWidth: true
                    onAccepted: root.handleLogin()
                }

                LoginButton {
                    id: loginBtn
                    scaleFactor: root.scaleFactor
                    Layout.fillWidth: true
                    onClicked: root.handleLogin()
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
            Layout.topMargin: Math.round(4 * root.scaleFactor)
        }
    }

    // Bottom Navigation Bar
    Item {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Math.round(28 * root.scaleFactor)
        height: Math.round(42 * root.scaleFactor)

        SessionSelector {
            id: sessionSelector
            scaleFactor: root.scaleFactor
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        PowerMenu {
            id: powerMenu
            scaleFactor: root.scaleFactor
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Component.onCompleted: {
        if (usernameInput.text.length > 0) {
            passwordInput.forceActiveFocus()
        } else {
            usernameInput.forceActiveFocus()
        }
    }
}