import QtQuick
import QtMultimedia
import "../theme"

Rectangle {
    id: root

    property real scaleFactor: 1.0
    property url musicSource: (typeof config !== "undefined" && config.MusicFile) ? config.MusicFile : ""
    property bool autoPlay: (typeof config !== "undefined" && config.PlayMusic === "true")
    property real defaultVolume: (typeof config !== "undefined" && config.Volume) ? Number(config.Volume) : 0.5
    property string trackTitle: "AETHER Atmosphere"

    height: Math.round(34 * root.scaleFactor)
    width: playerRow.implicitWidth + Math.round(24 * root.scaleFactor)
    radius: Math.round(AetherTheme.radiusSmall * root.scaleFactor)
    color: AetherTheme.bgCard
    border.color: AetherTheme.borderDefault
    border.width: 1
    visible: root.musicSource.toString().length > 0

    MediaPlayer {
        id: player
        source: root.musicSource
        loops: MediaPlayer.Infinite
        audioOutput: audioOut

        Component.onCompleted: {
            if (root.autoPlay && root.musicSource.toString().length > 0) {
                player.play()
            }
        }
    }

    AudioOutput {
        id: audioOut
        volume: root.defaultVolume
        muted: false
    }

    function fadeOutAndStop() {
        volumeFadeAnim.start()
    }

    NumberAnimation {
        id: volumeFadeAnim
        target: audioOut
        property: "volume"
        to: 0.0
        duration: 1500
        onFinished: player.stop()
    }

    Row {
        id: playerRow
        anchors.centerIn: parent
        spacing: Math.round(12 * root.scaleFactor)

        Text {
            text: "♪ " + root.trackTitle
            color: AetherTheme.textSecondary
            font.family: AetherTheme.fontFamily
            font.pixelSize: Math.round(AetherTheme.fontSizeFootnote * root.scaleFactor)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
            color: playArea.containsMouse ? AetherTheme.accentLavender : AetherTheme.textPrimary
            font.pixelSize: Math.round(12 * root.scaleFactor)
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: playArea
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (player.playbackState === MediaPlayer.PlayingState) {
                        player.pause()
                    } else {
                        player.play()
                    }
                }
            }
        }

        Text {
            text: audioOut.muted ? "🔇" : "🔊"
            color: muteArea.containsMouse ? AetherTheme.accentLavender : AetherTheme.textSecondary
            font.pixelSize: Math.round(12 * root.scaleFactor)
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: muteArea
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: audioOut.muted = !audioOut.muted
            }
        }
    }
}