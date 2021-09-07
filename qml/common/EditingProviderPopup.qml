import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: editingProviderPopup
    width: 450
    height: 250

    modal: true

    QtObject {
        id: editingProviderObject
        property string message: "Поле не может быть пустым"
        property string existsProviderNameError: "Поставщик с таким названием уже существует"
        property string fontFamily: "Decorative"
        property int fontPointSize: 10
        property int textTFPointSize: 14
        property string errorColor: "red"
        property string borderColor: "#5D76CB"
        property int borderWidth: 1
        property double oneTwoPart: 1/2
        property double oneThirdPart: 1/3
    }

    property string provider: ""
    property string phone: ""
    property string email: ""

    signal okClicked()

    function editingProviderData() {
        if(checkInputData()) {
           provider = providerEditingTF.text
           phone    = providerPhoneNumberTF.text
           email    = providerEmailTF.text
            okClicked()
            editingProviderPopup.close()
        }
    }

    onClosed: {messageLbl.visible = false; providerEditingTF.text = provider}

    function checkInputData() {
        var errorCounter = 0

        if(providerEditingTF.text.length === 0 && providerPhoneNumberTF.text.length === 0
                && providerEmailTF.text.length === 0) {
            messageLbl.text                 = editingProviderObject.message
            messageLbl.visible              = true
            providerPhoneMessageLbl.text    = editingProviderObject.message
            providerPhoneMessageLbl.visible = true
            providerEmailMessageLbl.text    = editingProviderObject.message
            providerEmailMessageLbl.visible = true
            errorCounter += 3
        } else {
            if(providerEditingTF.text.length === 0) {
                messageLbl.text    = editingProviderObject.message
                messageLbl.visible = true
                ++errorCounter
            } else if(providersModel.isExistsProviderName(providerEditingTF.text)) {
                messageLbl.text    = editingProviderObject.existsProviderNameError
                messageLbl.visible = true
                ++errorCounter
            } else {
               messageLbl.visible = false
            }

            if(providerPhoneNumberTF.text.length === 0) {
                providerPhoneMessageLbl.text    = editingProviderObject.message
                providerPhoneMessageLbl.visible = true
                ++errorCounter
            } else {
                providerPhoneMessageLbl.visible = false
            }

            if(providerEmailTF.text.length === 0) {
                providerEmailMessageLbl.text    = editingProviderObject.message
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

    Rectangle {
        id: editingProviderRect
        anchors.fill: parent
        border.width: editingProviderObject.borderWidth
        radius: 5
        border.color: editingProviderObject.borderColor

        ColumnLayout {
            id: tfColumnLayout
            width: editingProviderRect.width
            height: editingProviderRect.height * editingProviderObject.oneTwoPart

            TextField {
                id: providerEditingTF
                text: provider
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.textTFPointSize
                selectByMouse: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * editingProviderObject.oneTwoPart
            }

            Label {
                id: messageLbl
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.fontPointSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignHCenter
                color: editingProviderObject.errorColor
                visible: false

            }
            TextField {
                id: providerPhoneNumberTF
                text: phone
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                 Layout.preferredWidth: parent.width * editingProviderObject.oneTwoPart
                horizontalAlignment: TextInput.Center
                validator: RegularExpressionValidator {regularExpression: /^\+380\d{3}\d{2}\d{2}\d{2}$/}
            }

            Label {
                id: providerPhoneMessageLbl
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.fontPointSize
                color: editingProviderObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            TextField {
                id: providerEmailTF
                text: email
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * editingProviderObject.oneTwoPart
                horizontalAlignment: TextInput.Center
                validator: RegularExpressionValidator {regularExpression: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/}
            }

            Label {
                id: providerEmailMessageLbl
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.fontPointSize
                color: editingProviderObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }
        }

        RowLayout {
            id: btnRowLayout
            width: parent.width
            height: parent.height * editingProviderObject.oneTwoPart
            anchors.top: tfColumnLayout.bottom

            Button {
                id: editingBtn
                text: "Редактировать"
                font.family: editingProviderObject.fontFamily
                font.pointSize: editingProviderObject.textTFPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * editingProviderObject.oneTwoPart
                onClicked: editingProviderData()
            }
        }
    }

}
