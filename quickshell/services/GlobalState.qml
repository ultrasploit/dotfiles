pragma Singleton

import QtQuick
import "../types/"

QtObject {
    id: state

    property string islandMode: IslandMode.clock
}
