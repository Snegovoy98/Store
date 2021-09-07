import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Popup {
    id: root

    property alias info: info.text

    signal okClicked()
    signal cancelClicked()

    QtObject {
        id: messageBoxObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 25
    }

    modal: true
    focus: true

    ColumnLayout {
        id: column
        anchors.fill: parent

        Label {
            id: info
            font.family: messageBoxObject.fontFamily
            font.pointSize: messageBoxObject.fontPointSize
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Label.Wrap
        }

        MenuSeparator{Layout.fillWidth: true}

        RowLayout {
            Button {
                id: okBtn
                text: "OK"
                font.family: messageBoxObject.fontFamily
                highlighted: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    okClicked()
                    root.close()
                }
            }

            Button {
                id: cancelClicked
                text: "Отмена"
                font.family: messageBoxObject.fontFamily
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    cancelClicked()
                    root.close()
                }
            }
        }
    }
}
