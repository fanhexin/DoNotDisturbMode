// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Item {
    property alias text: label.text
    property alias color: label.color
    property alias fontSize: label.font.pixelSize
    property int lrMargin: UI.NORMAL_MARGIN
    height: label.height

    Label {
        id: label
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

            leftMargin: lrMargin
            rightMargin: lrMargin
        }
        font.weight: Font.Light
        color: theme.inverted ? "#d2d2d2" : "#505050"
    }
}
