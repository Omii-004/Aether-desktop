import QtQuick
import QtMultimedia
import "../theme"

Item {
    id: root

    property real scaleFactor: 1.0

    // Configuration Properties with Safe Defaults
    property string mode: (typeof config !== "undefined" && config.BackgroundMode) ?
                          config.BackgroundMode.toLowerCase() : "gradient"
    property url imageSource: (typeof config !== "undefined" && config.BackgroundImage && config.BackgroundImage !== "") ?
                              Qt.resolvedUrl(config.BackgroundImage) : ""
    property url videoSource: (typeof config !== "undefined" && config.BackgroundVideo && config.BackgroundVideo !== "") ?
                              Qt.resolvedUrl(config.BackgroundVideo) : ""

    property string backgroundFit: (typeof config !== "undefined" && config.BackgroundFit) ?
                                   config.BackgroundFit : "Cover"
    property string backgroundPosition: (typeof config !== "undefined" && config.BackgroundPosition) ?
                                        config.BackgroundPosition : "Center"

    property real backgroundDim: {
        if (typeof config !== "undefined" && config.BackgroundDim && !isNaN(Number(config.BackgroundDim))) {
            return Math.max(0.0, Math.min(0.60, Number(config.BackgroundDim)))
        }
        return 0.15
    }

    property bool enableGlow: (typeof config === "undefined" || config.EnableGlow === undefined ||
                               config.EnableGlow.toString().toLowerCase() === "true")

    anchors.fill: parent

    // Layer 1: Base Gradient (Always active baseline & safe fallback)
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
        source: root.imageSource
        visible: root.mode === "image" && status === Image.Ready
        asynchronous: true
        cache: true

        // Configurable Fit (Cover, Contain, Center, Fill)
        fillMode: {
            switch (root.backgroundFit.toLowerCase()) {
                case "contain": return Image.PreserveAspectFit;
                case "center":  return Image.Pad;
                case "fill":    return Image.Stretch;
                case "cover":
                default:        return Image.PreserveAspectCrop;
            }
        }

        // Configurable Horizontal Alignment
        horizontalAlignment: {
            var pos = root.backgroundPosition.toLowerCase()
            if (pos.indexOf("left") !== -1) return Image.AlignLeft
            if (pos.indexOf("right") !== -1) return Image.AlignRight
            return Image.AlignHCenter
        }

        // Configurable Vertical Alignment
        verticalAlignment: {
            var pos = root.backgroundPosition.toLowerCase()
            if (pos.indexOf("top") !== -1) return Image.AlignTop
            if (pos.indexOf("bottom") !== -1) return Image.AlignBottom
            return Image.AlignVCenter
        }
    }

    // Layer 3: Qt 6 Looping Video Backdrop
    MediaPlayer {
        id: videoPlayer
        videoOutput: videoOutput
        source: root.videoSource
        loops: MediaPlayer.Infinite

        onErrorOccurred: (error, errorString) => {
            console.log("AETHER Background Video Error:", errorString)
        }

        Component.onCompleted: {
            if (root.mode === "video" && root.videoSource.toString().length > 0) {
                videoPlayer.play()
            }
        }
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        fillMode: (root.backgroundFit.toLowerCase() === "contain") ?
                  VideoOutput.PreserveAspectFit : VideoOutput.PreserveAspectCrop
        visible: root.mode === "video" && videoPlayer.playbackState === MediaPlayer.PlayingState
    }

    // Layer 4: Atmospheric Contrast Scrim Overlay
    Rectangle {
        id: scrimOverlay
        anchors.fill: parent
        color: AetherTheme.scrimOverlay
        opacity: root.backgroundDim
        visible: opacity > 0.001 && (root.mode === "image" || root.mode === "video")
    }

    // Layer 5: Cinematic Ambient Breathing Glow
    Rectangle {
        id: ambientGlow
        width: Math.round(680 * root.scaleFactor)
        height: width
        radius: width / 2
        anchors.centerIn: parent
        color: AetherTheme.accentViolet
        opacity: 0.055
        visible: root.enableGlow

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: root.enableGlow && root.visible

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

    Component.onDestruction: {
        if (videoPlayer.playbackState === MediaPlayer.PlayingState) {
            videoPlayer.stop()
        }
    }
}