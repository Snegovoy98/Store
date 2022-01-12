import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12

Item {
    property int calendarWidth: 300
    property int calendarHeight: 350
    property string manualCheckDate: ""
    property string rangeDate: ""
    property double btnRowParam: 0.3

    QtObject {
        id: calendarObject

        property double oneSecondPart: 1/2
    }

    Calendar {
        id: calendar
        Layout.preferredWidth: parent.width * calendarObject.oneSecondPart
        anchors.horizontalCenter: parent.horizontalCenter
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: {
                rangeDate = calendar.selectedDate.toLocaleDateString(locale, Locale.ShortFormat)
                calendarDialog.close()
            }
        }
    }

    RowLayout {
        id: btnRow
        width: parent.width
        height: parent.height * btnRowParam
        anchors.top: calendar.bottom
        Button {
            id: dateBtn
            Layout.preferredWidth: parent.width
            height: 50
            text: "Добавить дату"
            onClicked: {
                manualCheckDate = calendar.selectedDate.toLocaleDateString(locale, Locale.ShortFormat)
                calendarDialog.close()
            }
        }
    }
}
