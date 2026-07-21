import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

import "./components/"
import "../services/"
import "../types/"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root

        required property var modelData
        screen: modelData

        anchors.top: true
        anchors.left: true
        anchors.right: true

        exclusiveZone: (Settings.islandTopMargin + Settings.islandHeight + Settings.islandBtmMargin)
        implicitHeight: modelData.height

        property string mode: Hyprland.focusedMonitor?.name === modelData.name ? GlobalState.islandMode : IslandMode.clock

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: (root.mode !== IslandMode.clock) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        color: (root.mode !== IslandMode.clock) ? Qt.rgba(0, 0, 0, 0.2) : Theme.transparent
        mask: Region {
            item: mask
        }

        MouseArea {
            z: 0
            anchors.fill: parent
            enabled: root.mode !== IslandMode.clock
            onClicked: {
                GlobalState.islandMode = IslandMode.clock;
            }
        }

        // Content
        Rectangle {
            id: content

            z: 1

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Settings.islandTopMargin

            radius: 15
            color: Theme.background

            implicitWidth: components.implicitWidth
            implicitHeight: components.implicitHeight

            // layer
            clip: true
            antialiasing: true
            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: mask
            }

            // animations
            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 320
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 320
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on radius {
                NumberAnimation {
                    duration: 300
                }
            }
            Behavior on anchors.topMargin {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            // components
            ColumnLayout {
                id: components
                anchors.centerIn: parent

                // Items
                Clock {
                    visible: root.mode === IslandMode.clock
                }
                Clock2 {
                    visible: root.mode === IslandMode.clock2
                }
                ActionBar {
                    visible: root.mode === IslandMode.actionBar
                }
            }
        }

        // Mask
        Rectangle {
            id: mask

            anchors.fill: content
            radius: content.radius

            visible: false
            layer.enabled: true
        }

        IpcHandler {
            target: "shell"

            function toggleLauncher(): void {
                if (root.mode !== IslandMode.actionBar) {
                    GlobalState.islandMode = IslandMode.actionBar;
                } else {
                    GlobalState.islandMode = IslandMode.clock;
                }
            }
        }
    }
}
