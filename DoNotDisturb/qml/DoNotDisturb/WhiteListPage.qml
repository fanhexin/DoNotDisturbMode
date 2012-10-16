// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "./UIConstants.js" as UI
import "./Data.js" as DATA

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
                if (contactsListModel.count) {
                    for (var i = 0; i < contactsListModel.count; i++) {
                        contactsListModel.get(i).bSelect = false;
                    }
                }

                var tmp = Qt.createComponent("./ContactsPicker.qml");
                var sheet = tmp.createObject(me);
                sheet.accepted.connect(function() {
                                           var wlnumbers = "";
                                           for (var i = 0; i < contactsListModel.count; i++) {
                                               if (contactsListModel.get(i).bSelect) {
                                                   if (!check(contactsListModel.get(i).id))
                                                       continue;
                                                   wlListView.model.append(contactsListModel.get(i));
                                                   DATA.wl_insert([
                                                                      contactsListModel.get(i).id,
                                                                      contactsListModel.get(i).name,
                                                                      contactsListModel.get(i).imgUrl,
                                                                      contactsListModel.get(i).number
                                                                  ]);
                                                   wlnumbers += ",";
                                                   wlnumbers += contactsListModel.get(i).number;
                                               }
                                           }
                                           updateWhiteList();

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
                                         wlListView.model.clear();
                                         DATA.wl_clear();
                                         updateWhiteList();
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
                    DATA.wl_del(wlListView.model.get(del_menu.index).id);
                    wlListView.model.remove(del_menu.index);
                    updateWhiteList();
                }
            }
        }
    }

    Header {
        id: header
        color: UI.HEADER_COLOR
        content: qsTr("Allow Calls From")
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
        model: whiteListModel
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
            visible: !wlListView.model.count
            color: "black"
        }
    }

    ScrollDecorator {
        flickableItem: wlListView
    }

    function check(id) {
        for (var j = 0; j < whiteListModel.count; j++) {
            if (whiteListModel.get(j).id == id)
                return false;
        }
        return true;
    }

    function updateWhiteList() {
        var tmp = "";
        if (wlListView.model.count >= 1) {
            tmp += wlListView.model.get(0).number
        }
        for (var i = 1; i < wlListView.model.count; i++) {
            tmp += ",";
            tmp += wlListView.model.get(i).number;
        }
        setting.setWhiteList(tmp);
    }
}
