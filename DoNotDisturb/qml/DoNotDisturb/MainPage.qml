import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait

    Header {
        id: header
        color: UI.HEADER_COLOR
        content: qsTr("Do Not Disturb")
    }

    Flickable {
        id: flickable
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        clip: true

        Column {
            id: col_1
            width: parent.width

            SpacingItem {}

            LabelItem {
                width: parent.width
                text: qsTr("When Do Not Disturb is enabled calls that arrive will be silenced.")
            }

            SpacingItem {}

            SectionItem {
                width: parent.width
                text: qsTr("Time Setting")
            }

            SpacingItem {}

            SwitchItem {
                id: scheduledSW
                width: parent.width
                text: qsTr("Scheduled")
                checked: setting.getActive()
                onCheckedChanged: {
                    setting.setActive(checked);
                }
            }

            TimePickerItem {
                id: startTimeItem
                width: parent.width
                text: qsTr("Start Time")
                describe: setting.getStartTime()
                onDescribeChanged: {
                    setting.setStartTime(describe);
                }
            }

            TimePickerItem {
                id: endTimeItem
                width: parent.width
                text: qsTr("End Time")
                describe: setting.getEndTime()
                onDescribeChanged: {
                    setting.setEndTime(describe);
                }
            }
        }

        Rectangle {
            id: col_2
            z: 2
            color: "#E0E1E2"
            width: parent.width
            height: col.height

            Column {
                id: col
                width: parent.width
                SpacingItem {}

                SectionItem {
                    width: parent.width
                    text: qsTr("White List Setting")
                }

                RowBtnItem {
                    width: parent.width
                    text: qsTr("Allow Calls From")
                    onItemClick: goto_page("./WhiteListPage.qml")
                }

                LabelItem {
                    width: parent.width
                    text: qsTr("Incoming calls from this list will not be silenced.")
                }

                SpacingItem {}

                SwitchItem {
                    width: parent.width
                    text: qsTr("Repeated Calls")
                    checked: setting.getRepeatedCall()
                    onCheckedChanged: {
                        setting.setRepeatedCall(checked);
                    }
                }

                LabelItem {
                    width: parent.width
                    text: qsTr("When enabled, a second call from the same person within three minutes will not be silenced.")
                }

                SpacingItem {}

                SectionItem {
                    width: parent.width
                    text: qsTr("Other")
                }

                PopupItem {
                    width: parent.width
                    text: qsTr("Feedback")
                    onItemClick: Qt.openUrlExternally('mailto:fanhexin@gmail.com')
                }

                SpacingItem {}
            }
        }
    }

    states: [
        State {
            name: "scheduledSWChecked"
            when: scheduledSW.checked
            PropertyChanges {
                target: col_2
                y: endTimeItem.y + endTimeItem.height
            }
            PropertyChanges {
                target: flickable
                contentHeight: col_1.height + col_2.height
            }
        },

        State {
            name: "scheduledSWunChecked"
            when: !scheduledSW.checked
            PropertyChanges {
                target: col_2
                y: scheduledSW.y + scheduledSW.height
            }
            PropertyChanges {
                target: flickable
                contentHeight: col_1.height + col_2.height- startTimeItem.height - endTimeItem.height
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "y"
            easing.type: Easing.InOutCirc
            duration: 200
        }
    }
}
