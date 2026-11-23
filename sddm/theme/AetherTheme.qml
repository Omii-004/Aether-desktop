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

    // v0.2.0 Cinematic Glassmorphism Tokens
    readonly property color glassSurface: "#AA080D1C"
    readonly property color glassSurfaceInner: "#55111A35"
    readonly property color glassBorder: "#337054C8"
    readonly property color glassBorderFocused: "#A99AFF"
    readonly property color scrimOverlay: "#080D1C"

    readonly property color accentViolet: "#7054C8"
    readonly property color accentVioletHover: "#8266DB"
    readonly property color accentLavender: "#A99AFF"

    readonly property color borderDefault: "#39466D"
    readonly property color borderFocused: "#7054C8"
    readonly property color borderGlow: "#557054C8"

    // Refined v0.2.0 Anime Typography Tones
    readonly property color textPrimary: "#E9E8F5"
    readonly property color textSecondary: "#A7A3BE"
    readonly property color textMuted: "#777B9C"
    readonly property color textPlaceholder: "#8586A5"

    readonly property color statusError: "#FF5C7A"
    readonly property color statusSuccess: "#48D597"

    // --- Typography Scale ---
    readonly property string fontFamily: "Sans Serif"
    readonly property int fontSizeClock: 84
    readonly property int fontSizeHeader: 22
    readonly property int fontSizeTitle: 16
    readonly property int fontSizeBody: 14
    readonly property int fontSizeDate: 14
    readonly property int fontSizeCaption: 12
    readonly property int fontSizeFootnote: 11

    readonly property int weightClock: Font.ExtraLight
    readonly property int weightHeader: Font.Medium
    readonly property int weightBody: Font.Normal

    readonly property real letterSpacingHeader: 6
    readonly property real letterSpacingNormal: 2
    readonly property real letterSpacingSubtle: 1

    // --- Geometry & Radii ---
    readonly property real radiusSmall: 9
    readonly property real radiusMedium: 14
    readonly property real radiusGlass: 18
    readonly property real radiusLarge: 22

    readonly property real panelWidth: 380
    readonly property real panelPadding: 26
    readonly property real controlHeight: 44

    // --- Responsive Safety Clamping Functions ---
    function responsiveCardWidth(scale) {
        return Math.max(320, Math.min(460, Math.round(panelWidth * scale)))
    }

    function responsiveSideMargin(scale) {
        return Math.max(36, Math.min(140, Math.round(80 * scale)))
    }

    function responsiveControlHeight(scale) {
        return Math.max(38, Math.min(52, Math.round(controlHeight * scale)))
    }

    // --- Animation Timings ---
    readonly property int animFast: 150
    readonly property int animNormal: 300
    readonly property int animSlow: 600
}