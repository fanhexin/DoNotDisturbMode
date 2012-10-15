// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Item {
    property alias text: label.text
    property alias checked: sw.checked
    property alias fontSize: label.font.pixelSize
    property alias color: label.color
    property int lrMargin: UI.NORMAL_MARGIN

    height: label.height > sw.height ? label.height : sw.height

    Label {
        id: label
        anchors {
            left: parent.left
            leftMargin: lrMargin
            verticalCenter: parent.verticalCenter
        }
        font.bold: true
    }

    Switch {
         id: sw
         anchors {
             right: parent.right
             rightMargin: lrMargin
             verticalCenter: parent.verticalCenter
         }
    }
}
