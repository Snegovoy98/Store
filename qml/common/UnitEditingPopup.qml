import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: unitEditingPopup
    width: 400
    height: 250

    signal okClicked()

    modal: true
    focus: true

    QtObject {
        id: unitEditingObject
        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorExistsMessage: "Такое название уже существует"
        property string errorEmptyMessage: "Поле не может быть пустым"
        property int borderWidth: 1
        property string borderColor: "#5D76CB"
        property double oneSecondPart: 1/2     
    }

    property string old_unit_value: ""
    property string new_unit_value: ""

    function addEditingData() {
         if(checkInputData()) {
           new_unit_value = unitTF.text
           okClicked()
           unitEditingPopup.close()
         }
    }

    function checkInputData() {
        var errorCounter = 0

        if(unitTF.text.length === 0) {
            unitMessage.text    = unitEditingObject.errorEmptyMessage
            unitMessage.visible = true
            ++errorCounter
        } else if (unitsModel.isExists(unitTF.text)) {
            unitMessage.text    = unitEditingObject.errorExistsMessage
            unitMessage.visible = true
            ++errorCounter
        } else {
            unitMessage.visible = false
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed: unitMessage.visible = false

    Rectangle {
        anchors.fill: parent
        border.width: unitEditingObject.borderWidth
        border.color: unitEditingObject.borderColor
        radius: 5

        ColumnLayout {
            anchors.fill: parent

            Label {
                text: "Введите новое значение единицы измерения"
                font.family: unitEditingObject.fontFamily
                font.pointSize: unitEditingObject.fontPointSize
                color: unitEditingObject.textColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * unitEditingObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
            }

            MenuSeparator {Layout.fillWidth: true}

            TextField {
                id: unitTF
                text: old_unit_value
                font.family: unitEditingObject.fontFamily
                font.pointSize: unitEditingObject.fontPointSize
                selectByMouse: true
                Layout.alignment: TextInput.AlignHCenter
                validator: RegExpValidator{regExp: /[А-Яа-я]+/}
                Layout.preferredWidth: parent.width * unitEditingObject.oneSecondPart
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                id: unitMessage
                color: unitEditingObject.errorColor
                font.family: unitEditingObject.fontFamily
                font.pointSize: unitEditingObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * unitEditingObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            Button {
                id: editBtn
                text: "Редактировать"
                font.family: unitEditingObject.fontFamily
                font.pointSize: unitEditingObject.fontPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                onClicked: addEditingData()
            }
        }
    }
}
