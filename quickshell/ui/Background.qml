import Quickshell
import Quickshell.Wayland

import QtQuick
import Qt5Compat.GraphicalEffects

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        WlrLayershell.layer: WlrLayer.Background

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        color: "transparent"

        Rectangle {
            id: container

            anchors.fill: parent
            color: "#0e0e0e"

            clip: true
            radius: 30

            Image {
                id: img
                z: 0
                anchors.fill: parent
                source: "file:///home/ultra/Pictures/Wallpapers/blue-forest.jpg"
                fillMode: Image.PreserveAspectCrop
                smooth: true
                visible: false
            }

            Rectangle {
                id: maskShape
                anchors.fill: parent
                radius: 30
                visible: false
            }

            OpacityMask {
                anchors.fill: img
                source: img
                maskSource: maskShape
            }
        }
    }
}
