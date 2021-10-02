import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: root
    width: 450
    height: 350

    modal: true
    focus: true

    property string provider: ""
    property string category: ""
    property string product: ""
    property string product_unit: ""
    property double old_balance_beginning_value: 0
    property double old_report_data_value: 0
    property double old_write_off_data_value: 0
    property bool isFirstBalanceBeginningValue: false
    property int position: 0

    QtObject {
        id: accountingObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 14
        property string textColor: "black"
        property string errorColor: "red"
        property string errorEmptyMessage: "Поле не может быть пустым"
        property string errorNullMessage: "Значение не может быть меньше или равным нулю"
        property string borderColor: "#5D76CB"
        property int borderWidth: 1
        property double oneSecondPart: 1/2

    }

    function editingAccountingData() {
            if(checkInputData()) {
                accountingModel.recalculatingAccountingData(provider, category, product, product_unit, balanceBeginningEditingTF.text,
                                                            reportDataEditingTF.text, writeOffEditingTF.text, old_balance_beginning_value, position)
                balanceBeginningEditingTF.clear()
                reportDataEditingTF.clear()
                writeOffEditingTF.clear()
                root.close()
            }
    }

    function checkInputData() {
        var errorCounter = 0
        if(balanceBeginningEditingTF.text.length === 0 &&
           reportDataEditingTF.text.length === 0 &&
           writeOffEditingTF.text.length === 0) {
            balanceBeginningEditingMessageLbl.text      = accountingObject.errorEmptyMessage
            balanceBeginningEditingMessageLbl.visible   = true
            reportDataEditingMessageLbl.text            = accountingObject.errorEmptyMessage
            reportDataEditingMessageLbl.visible         = true
            writeOffEditingMessageLbl.text              = accountingObject.errorEmptyMessage
            writeOffEditingMessageLbl.visible           = true
            errorCounter += 3
        } else {
            if(balanceBeginningEditingTF.text.length === 0) {
                balanceBeginningEditingMessageLbl.text     = accountingObject.errorEmptyMessage
                balanceBeginningEditingMessageLbl.visible  = true
                ++errorCounter
            } else if(parseFloat(balanceBeginningEditingTF.text) <= 0) {
                balanceBeginningEditingMessageLbl.text     = accountingObject.errorNullMessage
                balanceBeginningEditingMessageLbl.visible  = true
                ++errorCounter
            } else {
                balanceBeginningEditingMessageLbl.visible  = false
            }

            if(reportDataEditingTF.text.length === 0) {
                reportDataEditingMessageLbl.text    = accountingObject.errorEmptyMessage
                reportDataEditingMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(reportDataEditingTF.text) <= 0) {
                reportDataEditingMessageLbl.text    = accountingObject.errorNullMessage
                reportDataEditingMessageLbl.visible = true
                ++errorCounter
            } else {
                reportDataEditingMessageLbl.visible = false
            }

            if(writeOffEditingTF.text.length === 0) {
                writeOffEditingMessageLbl.text     = accountingObject.errorEmptyMessage
                writeOffEditingMessageLbl.visible  = true
                ++errorCounter
            } else if(parseFloat(writeOffEditingTF.text) <= 0) {
                writeOffEditingMessageLbl.text     = accountingObject.errorNullMessage
                writeOffEditingMessageLbl.visible  = true
                ++errorCounter
            } else {
                writeOffEditingMessageLbl.visible  = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed: {
        balanceBeginningEditingMessageLbl.visible  = false
        reportDataEditingMessageLbl.visible = false
        writeOffEditingMessageLbl.visible  = false
    }

    Rectangle {
        anchors.fill: parent
        border.width: accountingObject.borderWidth
        border.color: accountingObject.borderColor
        radius: 5

        ColumnLayout {
            anchors.fill: parent

            Label {
                text: "Остаток на начало"
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                font.bold: true
                color: accountingObject.textColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
            }

            TextField {
                id: balanceBeginningEditingTF
                text: old_balance_beginning_value
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                readOnly: isFirstBalanceBeginningValue? false: true
            }

            Label {
                id: balanceBeginningEditingMessageLbl
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                color: accountingObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: "Данные отчета"
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                font.bold: true
                color: accountingObject.textColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
            }

            TextField {
                id: reportDataEditingTF
                text: old_report_data_value
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                id: reportDataEditingMessageLbl
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                color: accountingObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: "Списание"
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                font.bold: true
                color: accountingObject.textColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
            }

            TextField {
                id: writeOffEditingTF
                text: old_write_off_data_value
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
            }

            Label {
                id: writeOffEditingMessageLbl
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                color: accountingObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                id: editingBtn
                text: "Редактировать"
                font.family: accountingObject.fontFamily
                font.pointSize: accountingObject.fontPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                onClicked: editingAccountingData()
            }
        }
    }
}
