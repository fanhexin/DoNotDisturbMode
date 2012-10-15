// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

        ToolIcon {
            iconId: "toolbar-add"
            onClicked: {
                var tmp = Qt.createComponent("./ContactsPicker.qml");
                var sheet = tmp.createObject(me, {
                                                 wlModel: wlContactsModel
                                             });

                sheet.open();
            }
        }

        ToolIcon {
            iconId: "toolbar-delete"
            onClicked: {
                var tmp = Qt.createComponent('./AlarmDlg.qml');
                var dlg = tmp.createObject(me, {
                                               title_text: qsTr("Warning"),
                                               title_img: "image://theme/icon-l-error",
                                               content_text: qsTr("Would you like to empty the list?")
                                           });
                dlg.accepted.connect(function() {
                                         wlContactsModel.clear();
                                         contacts.clearWhiteList();
                                     });
                dlg.open();

            }
        }
    }

    Menu {
        id: del_menu
        property int index
        MenuLayout {
            MenuItem {
                text: qsTr("Delete")
                onClicked: {
                    wlContactsModel.remove(del_menu.index);
                    var tmp = [];
                    for (var i = 0; i < wlContactsModel.count; i++) {
                        tmp.push(wlContactsModel.get(i).id);
                    }
                    contacts.updateWhiteList(tmp);
                }
            }
        }
    }


    Header {
        id: header
        color: UI.HEADER_COLOR
        content: qsTr("Allow Calls From")
    }

    ListModel {
        id: wlContactsModel
    }

    ListView {
        id: wlListView

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        clip: true
        model: wlContactsModel
        delegate: Component {
            Item {
                width: parent.width
                height: 80

                Rectangle {
                    id: bkg
                    z: -1
                    anchors.fill: parent
                    color: '#2A8EE0'
                    visible: mouseArea.pressed
                }

                Image {
                    id: contactImage
                    source: "image://theme/meegotouch-avatar-placeholder-background"
                    visible: !model.imgUrl

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: UI.NORMAL_MARGIN
                    }

                    smooth: true


                    Text {
                        id: tagName
                        anchors.centerIn: parent
                        color: "white"
                        font { bold: true; pixelSize: 32 }
                        visible: (!model.imgUrl)
                        text: name.charAt(0).toUpperCase()
                    }
                }

                Loader {
                    anchors.fill: contactImage
                    sourceComponent: (model.imgUrl)?contactPicCom:null
                }

                Component {
                    id: contactPicCom
                    MaskedItem {
                         mask: Image {
                             source: "image://theme/meegotouch-avatar-placeholder-background"
                         }

                         Image {
                             anchors.fill: parent
                             source: model.imgUrl
                         }
                    }
                }

                Label {
                    id: contactName
                    anchors {
                        left: contactImage.right
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }

                    font.bold: true
                    color: "black"
                    text: name
                    maximumLineCount: 1
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onPressAndHold: {
                        del_menu.index = model.index;
                        del_menu.open();
                    }
                }
            }
        }

        Text {
            id: blankscreentext
            anchors.centerIn: parent
            text: qsTr("No Contacts")
            font.pixelSize: 48
            opacity: 0.7
            visible: !wlContactsModel.count
            color: "black"
        }
    }

    ScrollDecorator {
        flickableItem: wlListView
    }

    Component.onCompleted: {
        var ret = contacts.getWhiteList();
        for (var i = 0; i < ret.length; i++) {
            wlContactsModel.append(ret[i]);
        }
    }
}
