import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: unitPopup

    width: 400
    height: 250

    modal: true
    focus: true

    QtObject {
        id: unitObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorExistsMessage: "Такая единица измерения уже существует!"
        property string emptyError: "Поле не может быть пустым"
        property double oneSecondPart: 1/3
    }

    function addUnitData() {
        if(checkInputData()) {
            unitsModel.addUnit(unitTF.text)
            unitTF.clear()
            unitPopup.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0

        if(unitTF.text.length === 0) {
            unitMessage.text    = unitObject.emptyError
            unitMessage.visible = true
            ++errorCounter
        } else if(unitsModel.isExists(unitTF.text)) {
            unitMessage.text    = unitObject.errorExistsMessage
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

    onClosed: {
        unitTF.clear()
        unitMessage.visible = false
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Введите название единицы измерения товара"
            font.family: unitObject.fontFamily
            font.pointSize: unitObject.fontPointSize
            color: unitObject.textColor
            Layout.alignment:Qt.AlignHCenter
        }

        MenuSeparator{Layout.fillWidth: true}

        TextField {
            id: unitTF
            placeholderText: "Введите единицу измерения"
            font.family: unitObject.fontFamily
            font.pointSize: unitObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator {regExp: /[А-Яa-я]+/}
        }

        Label {
            id: unitMessage
            font.family: unitObject.fontFamily
            font.pointSize: unitObject.fontPointSize
            color: unitObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * unitObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Button {
            id: addBtn
            text: "Добавить"
            font.family: unitObject.fontFamily
            font.pointSize: unitObject.fontPointSize
            highlighted: true
            Layout.alignment: Qt.AlignHCenter
            onClicked: addUnitData()
        }
    }
}
