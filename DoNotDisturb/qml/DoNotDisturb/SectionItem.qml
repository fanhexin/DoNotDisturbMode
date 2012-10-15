// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Item {
    property alias text: label.text
    property alias fontSize: label.font.pixelSize
    property alias color: label.color
    property int lrMargin: UI.NORMAL_MARGIN

    height: label.height

    Image {
        id: img
        anchors {
            left: parent.left
            leftMargin: lrMargin
            right: label.left
            rightMargin: UI.NORMAL_MARGIN
            verticalCenter: parent.verticalCenter
        }

        source: (theme.inverted)?"image://theme/meegotouch-groupheader-inverted-background":"image://theme/meegotouch-groupheader-background"
    }

    Label {
        id: label
        anchors {
            right: parent.right
            rightMargin: lrMargin
            verticalCenter: parent.verticalCenter
        }

        font.pixelSize: UI.FONT_SIZE_SMALL
        font.weight: Font.Light
        color: theme.inverted ? "#d2d2d2" : "#505050"
    }
}
