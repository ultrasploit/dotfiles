import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

import "../../types/"
import "../../services/"

FocusScope {
    id: root

    implicitWidth: 500
    implicitHeight: layout.implicitHeight

    property string mode: input.text.startsWith("=") ? "calc" : "launcher"
    property var allEntries: {
        var entries = [];

        if (root.mode === "launcher") {
            for (var i = 0; i < DesktopEntries.applications.values.length; i++) {
                var e = DesktopEntries.applications.values[i];
                entries.push({
                    name: e.name,
                    icon: e.icon,
                    comment: e.comment,
                    entry: e
                });
            }
            entries.sort((a, b) => a.name.localeCompare(b.name));
        }

        return entries;
    }

    property var filteredEntries: {
        if (mode === "launcher") {
            const filtered = allEntries.filter(a => a.name.toLowerCase().includes(input.text.toLowerCase()));
            if (filtered.length === 0) {
                list.currentIndex = -1;
                return [
                    {
                        icon: "help-circle",
                        name: "No items",
                        comment: "",
                        entry: null
                    }
                ];
            }

            list.currentIndex = 0;
            return filtered;
        } else if (mode === "calc") {
            const expr = input.text.substring(1);
            if (expr.length === 0) {
                return [
                    {
                        icon: "=",
                        name: "Start calculating..."
                    }
                ];
            }

            try {
                const result = eval(expr);

                return [
                    {
                        icon: "󰇼",
                        name: result.toString(),
                        comment: expr,
                        entry: null
                    }
                ];
            } catch (e) {
                return [
                    {
                        icon: "",
                        name: "Invalid expression",
                        comment: e.toString(),
                        entry: null
                    }
                ];
            }
        }
        return allEntries;
    }

    ScriptModel {
        id: filteredModel
        values: root.filteredEntries
    }

    function launch(app) {
        app.entry.execute();
        input.text = "";
        root.close();
    }

    function close() {
        list.positionViewAtIndex(list.currentIndex, ListView.Contain);
        list.currentIndex = 0;
        GlobalState.islandMode = IslandMode.clock;
        input.text = "";
    }

    onVisibleChanged: {
        if (visible) {
            forceFocus.start();
            list.currentIndex = 0;
            input.text = "";
        }
    }

    Component.onCompleted: {
        if (visible)
            forceFocus.start();
    }

    Timer {
        id: forceFocus
        interval: 0
        onTriggered: input.forceActiveFocus()
    }

    ColumnLayout {
        id: layout

        width: parent.width
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 14

        // Action bar
        Rectangle {
            id: actionBar

            Layout.fillWidth: true
            Layout.preferredHeight: 50

            radius: 14
            color: Theme.transparent

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14

                Text {
                    text: "󰍉"
                    color: Theme.accent
                    font.family: "JetBrainsMono Nerd Font Propo"
                    font.pixelSize: 18
                }

                TextField {
                    id: input

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    background: Item {}
                    color: Theme.text

                    placeholderText: "Search Apps or Enter a command"
                    placeholderTextColor: Theme.placeholder

                    selectByMouse: true
                    font.pixelSize: 15

                    onTextChanged: {
                        console.log("ax");
                        list.currentIndex = 0;
                        list.positionViewAtIndex(0, ListView.Beginning);
                    }
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            input.text = "";
                            root.close();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            if (root.mode === "launcher" && filteredEntries.length > 0) {
                                list.currentIndex = Math.min(list.currentIndex + 1, filteredEntries.length - 1);
                                list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                                event.accepted = true;
                            }
                        } else if (event.key === Qt.Key_Up) {
                            if (root.mode === "launcher" && filteredEntries.length > 0) {
                                list.currentIndex = Math.max(list.currentIndex - 1, 0);
                                list.positionViewAtIndex(list.currentIndex, ListView.Contain);
                                event.accepted = true;
                            }
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (root.mode === "launcher")
                                root.launch(filteredEntries[list.currentIndex]);
                            event.accepted = true;
                        }
                    }
                }
            }

            // Bottom accent line
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                height: 1
                radius: 1
                color: Theme.accent
            }
        }

        // Results
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.filteredEntries.length >= 6 ? (6 * 60) + (5 * 8) + 14 : (root.filteredEntries.length * 60) + ((root.filteredEntries.length - 1) * 8) + 14

            ListView {
                id: list

                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                anchors.bottomMargin: 14

                clip: true
                spacing: 8
                model: filteredModel

                currentIndex: 0
                highlightMoveDuration: 100

                interactive: false
                boundsBehavior: Flickable.StopAtBounds

                add: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 160
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 0.92
                        to: 1
                        duration: 160
                        easing.type: Easing.OutCubic
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 120
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 1
                        to: 0.92
                        duration: 120
                        easing.type: Easing.InCubic
                    }
                }

                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 160
                        easing.type: Easing.OutCubic
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width: list.width
                    height: 60

                    radius: 15
                    color: index === list.currentIndex ? Theme.accent : Theme.transparent

                    MouseArea {
                        id: tileMouse
                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        visible: root.mode === "launcher" && modelData.icon !== "help-circle"

                        onClicked: {
                            list.currentIndex = index;
                            root.launch(modelData);
                        }
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 14

                        Rectangle {
                            width: 36
                            height: 36

                            color: Theme.transparent
                            Text {
                                anchors.centerIn: parent
                                visible: root.mode === "calc"

                                text: "="
                                font.family: "JetBrainsMono Nerd Font Propo"
                                font.pixelSize: 28

                                color: Theme.background
                            }
                            Image {
                                anchors.centerIn: parent
                                visible: root.mode !== "calc"
                                width: 34
                                height: 34

                                source: Quickshell.iconPath(modelData.icon, false)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: modelData.name

                                font.pixelSize: 13
                                color: root.mode === "calc" ? Theme.background : Theme.text
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: !!modelData.comment
                                text: modelData.comment

                                font.pixelSize: 10
                                color: root.mode === "calc" ? Theme.background : Theme.placeholder
                            }
                        }
                    }
                }
            }
        }
    }
}
