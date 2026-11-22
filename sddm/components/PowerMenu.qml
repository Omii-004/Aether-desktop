import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    id: root

    property real scaleFactor: 1.0
    spacing: Math.round(10 * root.scaleFactor)

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "⏾"
        tooltipText: "Suspend"
        visible: (typeof sddm === "undefined") || sddm.canSuspend
        onClicked: {
            if (typeof sddm !== "undefined") sddm.suspend()
            else console.log("SDDM action: Suspend")
        }
    }

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "↻"
        tooltipText: "Reboot"
        visible: (typeof sddm === "undefined") || sddm.canReboot
        onClicked: {
            if (typeof sddm !== "undefined") sddm.reboot()
            else console.log("SDDM action: Reboot")
        }
    }

    ActionIcon {
        scaleFactor: root.scaleFactor
        iconText: "⏻"
        tooltipText: "Power Off"
        visible: (typeof sddm === "undefined") || sddm.canPowerOff
        onClicked: {
            if (typeof sddm !== "undefined") sddm.powerOff()
            else console.log("SDDM action: Power Off")
        }
    }
}