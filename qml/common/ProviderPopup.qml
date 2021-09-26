import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: providerPopup
    width: 450
    height: 350

    modal: true
    focus: true

    QtObject {
        id: providerPopupObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 14
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string errorPhoneMessage: "Номер слишком короткий"
        property string errorEmailMessage: "Неверный формат email"
        property string existsErrorMessage: "Поставщик с таким названием уже существует"
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
    }

    function addingProviderData() {
        if(checkInputData()) {
            providersModel.addProviderData(providerTF.text, providerPhoneNumberTF.text, providerEmailTF.text)
            providerTF.clear()
            providerPhoneNumberTF.clear()
            providerEmailTF.clear()
            providerPopup.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0
        if(providerTF.text.length === 0 && providerPhoneNumberTF.text.length === 0 &&
                providerEmailTF.text.length === 0) {
            providerMessageLbl.text         = providerPopupObject.errorMessage
            providerMessageLbl.visible      = true
            providerPhoneMessageLbl.text    = providerPopupObject.errorMessage
            providerPhoneMessageLbl.visible = true
            providerEmailMessageLbl.text    = providerPopupObject.errorMessage
            providerEmailMessageLbl.visible = true
            errorCounter += 3
        } else {
            if(providerTF.text.length === 0) {
                providerMessageLbl.text    = providerPopupObject.errorMessage
                providerMessageLbl.visible = true
                ++errorCounter
            } else if(providersModel.isExistsProviderName(providerTF.text)) {
                providerMessageLbl.text    = providerPopupObject.existsErrorMessage
                providerMessageLbl.visible = true
                ++errorCounter
            } else {
               providerMessageLbl.visible = false
            }

            if(providerPhoneNumberTF.text.length === 0) {
                providerPhoneMessageLbl.text    = providerPopupObject.errorMessage
                providerPhoneMessageLbl.visible = true
                ++errorCounter
            } else if(providerPhoneNumberTF.text.length >= 1 && providerPhoneNumberTF.text.length < 13) {
                providerPhoneMessageLbl.text    = providerPopupObject.errorPhoneMessage
                providerPhoneMessageLbl.visible = true
                ++errorCounter
            } else {
               providerPhoneMessageLbl.visible = false
            }

            if(providerEmailTF.text.length === 0) {
                providerEmailMessageLbl.text    = providerPopupObject.errorMessage
                providerEmailMessageLbl.visible = true
                ++errorCounter
            } else {
                providerEmailMessageLbl.visible = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed:  providerMessageLbl.visible = false

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent

        Label {
            text: "Введите данные о поставщике"
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.Center
            color: providerPopupObject.textColor
        }

        MenuSeparator {Layout.fillWidth: true}

        TextField {
            id: providerTF
            placeholderText: "Введите название поставщика"
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.Center
        }

        Label {
            id: providerMessageLbl
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            color: providerPopupObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        TextField {
            id: providerPhoneNumberTF
            placeholderText: "Введите номер телефона поставщика"
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.Center
            validator: RegularExpressionValidator {regularExpression: /^\+380\d{3}\d{2}\d{2}\d{2}$/}
        }

        Label {
            id: providerPhoneMessageLbl
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            color: providerPopupObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        TextField {
            id: providerEmailTF
            placeholderText: "Введите электронную почту поставщика"
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.Center
            validator: RegularExpressionValidator {regularExpression: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/}
        }

        Label {
            id: providerEmailMessageLbl
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            color: providerPopupObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Button {
            id: addBtn
            text: "Добавить"
            Layout.preferredWidth: parent.width
            highlighted: true
            font.family: providerPopupObject.fontFamily
            font.pointSize: providerPopupObject.fontPointSize
            onClicked: addingProviderData()
        }
    }
}
