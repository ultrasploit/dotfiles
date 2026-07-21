import QtQuick
import QtQuick.Layouts

import Quickshell
import "../../services/"

Rectangle {
    id: root

    implicitWidth: 120
    implicitHeight: Settings.islandHeight

    Layout.alignment: Qt.AlignHCenter
    color: Theme.transparent

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: Theme.accent

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
    }
}
