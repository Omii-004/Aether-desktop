import QtQuick
import QtMultimedia
import "../theme"

Item {
    id: root

    property real scaleFactor: 1.0
    property string mode: (typeof config !== "undefined" && config.BackgroundMode) ? config.BackgroundMode : "gradient"
    property url imageSource: (typeof config !== "undefined" && config.BackgroundImage) ? config.BackgroundImage : ""
    property url videoSource: (typeof config !== "undefined" && config.BackgroundVideo) ? config.BackgroundVideo : ""

    anchors.fill: parent

    // Layer 1: Base Gradient (Always present as baseline & safe fallback)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: AetherTheme.bgDark }
            GradientStop { position: 0.5; color: AetherTheme.bgSurface }
            GradientStop { position: 1.0; color: AetherTheme.bgDark }
        }
    }

    // Layer 2: Static Image Backdrop
    Image {
        id: bgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: root.imageSource
        visible: root.mode === "image" && status === Image.Ready
        asynchronous: true
        cache: true
    }

    // Layer 3: Qt 6 Video Loop Backdrop
    MediaPlayer {
        id: videoPlayer
        videoOutput: videoOutput
        source: root.videoSource
        loops: MediaPlayer.Infinite

        Component.onCompleted: {
            if (root.mode === "video" && root.videoSource != "") {
                videoPlayer.play()
            }
        }
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        visible: root.mode === "video" && videoPlayer.playbackState === MediaPlayer.PlayingState
    }

    // Layer 4: Cinematic Ambient Breathing Glow
    Rectangle {
        id: ambientGlow
        width: Math.round(680 * root.scaleFactor)
        height: width
        radius: width / 2
        anchors.centerIn: parent
        color: AetherTheme.accentViolet
        opacity: 0.055

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: true

            NumberAnimation {
                to: 0.085
                duration: 4000
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                to: 0.040
                duration: 4000
                easing.type: Easing.InOutQuad
            }
        }
    }
}