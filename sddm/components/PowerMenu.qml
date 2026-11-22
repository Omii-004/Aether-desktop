import QtQuick
import "../theme"

Row {
    id: root

    property real scaleFactor: 1.0
    spacing: Math.round(10 * root.scaleFactor)

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "⏾"
        tooltipText: "Suspend"
        onClicked: {
            if (typeof sddm !== "undefined" && sddm.canSuspend) {
                sddm.suspend()
            } else {
                console.log("SDDM action: Suspend")
            }
        }
    }

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "↻"
        tooltipText: "Reboot"
        onClicked: {
            if (typeof sddm !== "undefined" && sddm.canReboot) {
                sddm.reboot()
            } else {
                console.log("SDDM action: Reboot")
            }
        }
    }

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "⏻"
        tooltipText: "Power Off"
        onClicked: {
            if (typeof sddm !== "undefined" && sddm.canPowerOff) {
                sddm.powerOff()
            } else {
                console.log("SDDM action: Power Off")
            }
        }
    }
}