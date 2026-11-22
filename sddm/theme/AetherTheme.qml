pragma Singleton
import QtQuick

QtObject {
    id: theme

    // --- Color Palette ---
    readonly property color bgDark: "#080D1C"
    readonly property color bgSurface: "#111A35"
    readonly property color bgSurfaceTranslucent: "#CC111A35"
    readonly property color bgCard: "#1B2545"
    readonly property color bgCardHover: "#232F55"

    readonly property color accentViolet: "#7054C8"
    readonly property color accentVioletHover: "#8266DB"
    readonly property color accentLavender: "#A99AFF"

    readonly property color borderDefault: "#39466D"
    readonly property color borderFocused: "#7054C8"
    readonly property color borderGlow: "#557054C8"

    readonly property color textPrimary: "#F1EEFF"
    readonly property color textSecondary: "#AAA9C7"
    readonly property color textMuted: "#777B9C"
    readonly property color textPlaceholder: "#8586A5"

    readonly property color statusError: "#FF5C7A"
    readonly property color statusSuccess: "#48D597"

    // --- Typography Scale ---
    readonly property string fontFamily: "Sans Serif"
    readonly property int fontSizeClock: 92
    readonly property int fontSizeHeader: 24
    readonly property int fontSizeTitle: 17
    readonly property int fontSizeBody: 14
    readonly property int fontSizeDate: 15
    readonly property int fontSizeCaption: 12
    readonly property int fontSizeFootnote: 11

    readonly property real letterSpacingHeader: 8
    readonly property real letterSpacingNormal: 2
    readonly property real letterSpacingSubtle: 1

    // --- Geometry & Radii ---
    readonly property real radiusSmall: 9
    readonly property real radiusMedium: 14
    readonly property real radiusLarge: 22

    readonly property real panelWidth: 420
    readonly property real panelPadding: 30
    readonly property real controlHeight: 46

    // --- Animation Timings ---
    readonly property int animFast: 150
    readonly property int animNormal: 300
    readonly property int animSlow: 600
}