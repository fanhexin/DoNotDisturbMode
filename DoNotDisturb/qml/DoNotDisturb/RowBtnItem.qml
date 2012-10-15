// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Item {
    property int titleWeight: Font.Bold
    property color titleColor: theme.inverted ? "#ffffff" : "#282828"

    property int subtitleWeight: Font.Light
    property color subtitleColor: theme.inverted ? "#d2d2d2" : "#505050"

    property alias text: mainText.text
    property alias describe: subText.text
    property alias font_pixelSize: mainText.font.pixelSize
    property alias icon: img.source
    property int lrMargin: UI.NORMAL_MARGIN

    signal itemClick

    height: col.height + 2*UI.NORMAL_MARGIN

    Column {
        id: col
        anchors {
            left: parent.left
            leftMargin: lrMargin
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: mainText
            font.weight: titleWeight
            color: titleColor
        }

        Label {
            id: subText
            font.weight: subtitleWeight
            font.pixelSize: UI.FONT_SIZE_SMALL
            color: subtitleColor
            visible: text != ""
        }
    }

    Image {
        id: img
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors {
            right: parent.right
            rightMargin: lrMargin
            verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        z: -1
        anchors.fill: parent
        color: '#2A8EE0'
        visible: mouse_area.pressed
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: itemClick()
    }
}
