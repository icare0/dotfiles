import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main

    // ---- Easy-to-edit settings ----
    property int speed: 5000          // scroll animation speed
    property int animDuration: 150    // ms for scroll animation
    property real zoomScale: 0.8      // scale of the tile at screen center (peak)
    property real edgeScale: 0.3      // scale of tiles at the screen edges (trough)
    property real skewFactor: 0       // italic-style shear on tiles
    property int baseSpacing: 8       // resting gap between tiles
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

        property bool readyDone: false

        onStatusChanged: {
            if (status === FolderListModel.Ready && count > 0 && !readyDone) {
                readyDone = true
                const middle = Math.floor(count / 2)
                list.selectedIndex = middle
                list.centerOnIndex(middle)
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: folderModel
        orientation: ListView.Horizontal
        spacing: main.baseSpacing
        clip: true
        cacheBuffer: 600

        property int selectedIndex: 0
        property real tileWidth: (configs.number_of_pictures && configs.number_of_pictures > 0) ? (width / configs.number_of_pictures - 10) : 200
        property real viewportCenterX: width / 2

        function clampIndex(i) {
            return Math.max(0, Math.min(i, folderModel.count - 1))
        }

        function clampX(x) {
            return Math.max(0, Math.min(x, Math.max(0, contentWidth - width)))
        }

        function centerOnIndex(i) {
            const step = tileWidth + spacing
            const targetX = (i * step) - (width / 2) + (tileWidth / 2)
            contentX = clampX(targetX)
        }

        function activateCurrent() {
            if (folderModel.count <= 0) return
            const path = folderModel.get(selectedIndex, "filePath")
            Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), path])
            Qt.quit()
        }

        function ensureVisibleAnimated(i) {
            centerOnIndex(i)
        }

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
                onClicked: {
                    list.selectedIndex = index
                    list.activateCurrent()
                }

                onWheel: function(wheel) {
                    if (wheel.angleDelta.y < 0) {
                        list.moveSelection(1, 1)
                    } else if (wheel.angleDelta.y > 0) {
                        list.moveSelection(-1, 1)
                    }
                    wheel.accepted = true
                }
            }
        }

        Keys.onPressed: function(event) {
            const big = (configs.number_of_pictures && configs.number_of_pictures > 0) ? configs.number_of_pictures : 5

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
