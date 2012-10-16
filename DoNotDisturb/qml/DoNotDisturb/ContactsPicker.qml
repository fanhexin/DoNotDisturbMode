// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "./UIConstants.js" as UI

Sheet {
    id: me

    acceptButtonText: qsTr("Ok")
    rejectButtonText: qsTr("Cancel")

    title: Label{
        anchors.centerIn: parent
        text: qsTr("Select")
    }

    content: Item{
        id: contactList
        anchors.fill: parent

        Column {
            id: searchBarCol
            anchors.top: parent.top
            width: parent.width
            SearchBar {
                placeholderText: qsTr("Search")
                onTextChanged: {
                    contactListView.sync_model();
                    searchRetModel.clear();

                    if (!text) {
                        contactListView.model = contactsListModel;
                        return;
                    }

                    for (var i = 0; i < contactsListModel.count; i++) {
                        if (!contactsListModel.get(i).name.indexOf(text)) {
                            var tmp = contactsListModel.get(i);
                            tmp.recoverIndex = i;
                            searchRetModel.append(tmp);
                        }
                    }
                    contactListView.model = searchRetModel;
                }
            }
            SeparatorHLine {}
        }

        Text {
            id: blankscreentext
            anchors.centerIn: parent
            text: qsTr("No Contacts")
            font.pixelSize: 48
            opacity: 0.7
            visible: false
            color: "black"
        }

        BusyIndicator {
            id: spinner
            platformStyle: BusyIndicatorStyle { size: "large" }
            anchors.centerIn: parent
            running: spinner.visible
            visible: !contactsListModel.count
        }

        ListModel {
            id: searchRetModel
        }

        ListView {
            id: contactListView
            anchors {
                top: searchBarCol.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            clip: true
            model: contactsListModel
            delegate: Component {
                Item {
                    width: parent.width
                    height: 80

                    BorderImage {
                        source: "image://theme/meegotouch-list-fullwidth-background-selected"
                        width: parent.width; height: 80
                        border.left: 5; border.top: 5
                        border.right: 5; border.bottom: 5
                        visible: bSelect
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
                                 source: imgUrl
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

                        onClicked: {
                            contactListView.model.get(model.index).bSelect = !model.bSelect;
                            contactListView.sync_model();
                        }
                    }
                }
            }

     //       section.property: "name"
     //       section.criteria: ViewSection.FirstCharacter

     //       section.delegate: SectionItem {
     //           width: parent.width
     //           text: section.toUpperCase();
     //       }
            function sync_model() {
                for (var i = 0; i < searchRetModel.count; i++) {
                    contactsListModel.get(searchRetModel.get(i).recoverIndex).bSelect = searchRetModel.get(i).bSelect;
                }
            }
        }

        ScrollDecorator {
            flickableItem: contactListView
        }
    }

    onStatusChanged: {
        if (status == 1) {
            if (contactListView.model.count) {
                return;
            }
            load();
        }
    }

    function load() {
        var ret = contacts.getAll();
        if (!ret.length) {
            spinner.visible = false;
            blankscreentext.visible = true;
            return;
        }

        for (var i = 0; i < ret.length; i++) {
            ret[i].bSelect = false;
            contactListView.model.append(ret[i]);
        }
    }
}
