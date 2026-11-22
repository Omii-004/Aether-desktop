import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root

    property real scaleFactor: 1.0
    property string timeFormat: "hh:mm"
    property string dateFormat: "dddd, dd MMMM yyyy"

    property string currentTime: Qt.formatDateTime(new Date(), timeFormat)
    property string currentDate: Qt.formatDateTime(new Date(), dateFormat)

    spacing: Math.round(4 * scaleFactor)

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = Qt.formatDateTime(new Date(), root.timeFormat)
            root.currentDate = Qt.formatDateTime(new Date(), root.dateFormat)
        }
    }

    Text {
        text: "A E T H E R"
        color: AetherTheme.accentLavender
        font.family: AetherTheme.fontFamily
        font.pixelSize: Math.round(AetherTheme.fontSizeTitle * root.scaleFactor)
        font.letterSpacing: AetherTheme.letterSpacingHeader * root.scaleFactor
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
    }

    Text {
        text: root.currentTime
        color: AetherTheme.textPrimary
        font.family: AetherTheme.fontFamily
        font.pixelSize: Math.round(AetherTheme.fontSizeClock * root.scaleFactor)
        font.weight: Font.Light
        font.letterSpacing: AetherTheme.letterSpacingNormal * root.scaleFactor
        Layout.alignment: Qt.AlignHCenter
    }

    Text {
        text: root.currentDate
        color: AetherTheme.textSecondary
        font.family: AetherTheme.fontFamily
        font.pixelSize: Math.round(AetherTheme.fontSizeDate * root.scaleFactor)
        Layout.alignment: Qt.AlignHCenter
    }
}