// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "./UIConstants.js" as UI

Item {
    id: find_bar
    height: UI.HEADER_HEIGHT
    width: parent.width

    property alias placeholderText: text_fild.placeholderText
    property alias text: text_fild.text

    SearchTextField {
        id: text_fild
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: UI.SMALL_MARGIN
            rightMargin: UI.SMALL_MARGIN
            verticalCenter: parent.verticalCenter
        }
    }

    function text_fild_focus() {
        text_fild.text_fild_focus();
    }
}
