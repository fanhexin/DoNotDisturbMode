// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.extras 1.0

PopupItem {
    property alias hourMode: timePickerDlg.hourMode
    id: popupItem

    TimePickerDialog {
        id: timePickerDlg
        hourMode: DateTime.TwentyFourHours
        fields: DateTime.Hours | DateTime.Minutes
        titleText: popupItem.text
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
        onAccepted: {
            popupItem.describe = hour + ":" + (minute < 10 ? "0" : "" ) + minute;
        }
    }

    describe: "00:00"
    onItemClick: {
        var tmp = popupItem.describe.split(":");
        timePickerDlg.hour = tmp[0];
        timePickerDlg.minute = tmp[1];
        timePickerDlg.open();
    }
}
