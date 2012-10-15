import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Rectangle {
    width: parent.width
    height: UI.HEADER_HEIGHT

    property alias content: titleTxt.text
    property alias contentColor: titleTxt.color
    property alias contentFontSize: titleTxt.font.pixelSize
    property alias text_anchors: titleTxt.anchors

    Text {
        id: titleTxt
        anchors {
            left: parent.left
            leftMargin: UI.NORMAL_MARGIN
            verticalCenter: parent.verticalCenter
        }
        color: "white"
        font.pixelSize: UI.FONT_SIZE_LARGE
    }
}
