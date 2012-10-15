// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    property alias placeholderText: input.placeholderText
    property alias text: input.text

    width: parent.width
    height: 52

    TextField {
        id: input
        anchors.fill: parent
        platformStyle: TextFieldStyle { paddingRight: clearButton.width }
        inputMethodHints: Qt.ImhNoPredictiveText
        platformSipAttributes: SipAttributes {
            actionKeyLabel: qsTr("Finish")
            actionKeyHighlighted: true
        }
    }

    Image {
        id: clearButton
        anchors.right: input.right
        anchors.verticalCenter: input.verticalCenter
        source: "image://theme/"+((input.text=="")?"icon-m-common-search":"icon-m-input-clear")
        MouseArea {
            anchors.fill: parent
            onClicked: {
                input.text = "";
            }
        }
    }

    Keys.onPressed: {
        if(event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
            parent.focus = true;
            input.platformCloseSoftwareInputPanel();
        }
    }

    function text_fild_focus() {
        input.focus = true;
    }
}

