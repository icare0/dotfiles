import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main

    // ---- Easy-to-edit settings ----
    property int speed: 5000          // scroll animation speed
    property int animDuration: 100    // ms for scroll animation
    property real zoomScale: 0.8        // scale of the tile at screen center (peak)
    property real edgeScale: 0.3      // scale of tiles at the screen edges (trough)
    property real skewFactor: 0   // italic-style shear on tiles
    property int baseSpacing: 8       // resting gap between tiles (grows automatically as tiles magnify)
    // --------------------------------

    implicitHeight: 500
    implicitWidth: Screen.width
    color: "transparent"

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
    }

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: configs
            property string wallpaper_path
            property string cache_path
            property int number_of_pictures
            property string border_color
        }
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + (configs.wallpaper_path ? configs.wallpaper_path.replace("/home/rp34", Quickshell.env("HOME")).replace("$HOME", Quickshell.env("HOME")) : (Quickshell.env("HOME") + "/Pictures/Wallpapers/"))
        showDirs: false
        nameFilters: ["*.png", "*.jpg", "*.jpeg"]
        sortField: FolderListModel.Name
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: folderModel
        orientation: ListView.Horizontal
        spacing: main.baseSpacing
        clip: true
        cacheBuffer: 400

        property int selectedIndex: 0
        property real tileWidth: width / configs.number_of_pictures - 10
        property real viewportCenterX: width / 2

        function clampIndex(i) {
            return Math.max(0, Math.min(i, count - 1))
        }

        function clampX(x) {
            return Math.max(0, Math.min(x, contentWidth - width))
        }

        function activateCurrent() {
            const path = folderModel.get(selectedIndex, "filePath")
            Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), path])
            Qt.quit()
        }

        function ensureVisibleAnimated(i) {
            const step = tileWidth + spacing
            const itemStart = i * step
            const itemEnd = itemStart + tileWidth + 20

            if (itemStart < contentX)
                contentX = clampX(itemStart)
            else if (itemEnd > contentX + width)
                contentX = clampX(itemStart - (width - step))
        }

        // Moves the selection by `delta` tiles, animating at `speedMultiplier`x speed
        function moveSelection(delta, speedMultiplier) {
            anim.v = main.speed * speedMultiplier
            selectedIndex = clampIndex(selectedIndex + delta)
            ensureVisibleAnimated(selectedIndex)
        }

        Behavior on contentX {
            SmoothedAnimation {
                id: anim
                property int v: main.speed
                duration: main.animDuration
            }
        }

        delegate: Item {
            id: delegateItem
            height: 500
            property bool active: index === list.selectedIndex

            // Base (unscaled) slot width. Used to work out where this tile currently sits
            // on screen for the magnification curve below. Deliberately NOT derived from
            // this item's own (dynamic) width - if it were, width would depend on position
            // which would depend on width, i.e. a binding loop.
            readonly property real baseWidth: list.tileWidth

            property real targetScale: {
                const diff = Math.abs(index - list.selectedIndex)
                if (diff === 0) return 0.95
                if (diff === 1) return 0.65
                if (diff === 2) return 0.45
                return 0.32
            }

            property real scaleFactor: targetScale

            Behavior on scaleFactor {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.18
                }
            }

            width: baseWidth * scaleFactor

            Item {
                id: content
                anchors.centerIn: parent
                width: parent.width
                height: delegateItem.height * delegateItem.scaleFactor
                opacity: delegateItem.active ? 1.0 : 0.65

                Behavior on opacity {
                    NumberAnimation { duration: 180 }
                }

                Text {
                    id: alt
                    text: ""
                    color: configs.border_color
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    transform: Shear { xFactor: main.skewFactor }
                }

                Image {
                    id: img
                    anchors.fill: parent
                    opacity: 0.8
                    fillMode: Image.PreserveAspectCrop

                    asynchronous: true
                    cache: false
                    smooth: true

                    source: "file://" + (configs.cache_path ? configs.cache_path.replace("/home/rp34", Quickshell.env("HOME")).replace("$HOME", Quickshell.env("HOME")) : (Quickshell.env("HOME") + "/.cache/quickshell/thumbs/")) + fileName

                    // Decode once at the largest size this image will ever be shown at
                    // (the active/zoomed size), rather than tracking the animating
                    // width/height - that would re-decode on every animation frame
                    // and cause a visible blink.
                    sourceSize.width: delegateItem.baseWidth * main.zoomScale
                    sourceSize.height: delegateItem.height

                    transform: Shear { xFactor: main.skewFactor }

                    Timer {
                        id: retryTimer
                        interval: 1000
                        repeat: false
                        onTriggered: {
                            const s = img.source
                            img.source = ""
                            img.source = s
                        }
                    }

                    onStatusChanged: {
                        if (status === Image.Error) {
                            alt.text = "Caching"
                            retryTimer.start()
                        }
                    }
                }

                Rectangle {
                    id: border
                    z: 10
                    anchors.fill: parent
                    visible: delegateItem.active
                    color: "transparent"

                    border.width: 2
                    border.color: configs.border_color

                    transform: Shear { xFactor: main.skewFactor }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: list.selectedIndex = index
                onClicked: list.activateCurrent()

                onWheel: function(wheel) {
                    list.flick(-wheel.angleDelta.y * 8, 0)
                    wheel.accepted = true
                }
            }
        }

        Keys.onPressed: function(event) {
            const big = configs.number_of_pictures

            switch (event.key) {
            case Qt.Key_Right:
            case Qt.Key_L:
            case Qt.Key_J:
                moveSelection(1, 1)
                break
            case Qt.Key_Left:
            case Qt.Key_H:
            case Qt.Key_K:
                moveSelection(-1, 1)
                break
            case Qt.Key_D:
                moveSelection(big, big)
                break
            case Qt.Key_U:
                moveSelection(-big, big)
                break
            case Qt.Key_Space:
            case Qt.Key_Return:
                activateCurrent()
                break
            case Qt.Key_Escape:
                Qt.quit()
                break
            default:
                return
            }

            event.accepted = true
        }
    }
}
