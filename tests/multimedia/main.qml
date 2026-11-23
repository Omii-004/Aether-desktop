
import QtQuick
import QtQuick.Window
import QtMultimedia

Window {
    id: root

    width: 800
    height: 450
    visible: true
    title: "AETHER - Qt 6 Multimedia Test"
    color: "#080D1C"

    MediaPlayer {
        id: player

        audioOutput: AudioOutput {
            volume: 0.5
        }

        videoOutput: videoOutput
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
    }

    Text {
        anchors.centerIn: parent
        text: "AETHER Multimedia Module Loaded"
        color: "#A99AFF"
        font.pixelSize: 24
    }
}
