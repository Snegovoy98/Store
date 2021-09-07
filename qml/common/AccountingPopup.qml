import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: accountingPopup
    width: 450
    height: 480

    modal: true
    focus: true

    QtObject {
        id: accountingPopupObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 10
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string errorSelectMessage: "Выберите значение"
        property string errorNullMessage: "Значение не может быть меншье или равным нулю"
        property double oneSecondPart: 1/2
    }

    function addingAccountingData() {
        if(checkInputData())
            console.log("OK")
    }

    function checkInputData() {
        var errorCounter = 0
        if(accountingProviderTF.text.length === 0 && productCategoryCB.displayText === "" &&
           productCB.displayText === "" && productUnitCB.displayText === "" &&
           accountingBalanceBeginningTF.text.length === 0 && accountingReportDataTF.text.length === 0
           && accountingWriteOffTF.text.length === 0) {

          accountingProviderMessageLbl.text           = accountingPopupObject.errorMessage
          accountingProviderMessageLbl.visible        = true
          accountingProductCategoryMessageLbl.text    = accountingPopupObject.errorSelectMessage
          accountingProductCategoryMessageLbl.visible = true
          accountingProductMessageLbl.text            = accountingPopupObject.errorSelectMessage
          accountingProductMessageLbl.visible         = true
          accountingProductUnitMessageLbl.text        = accountingPopupObject.errorSelectMessage
          accountingProductUnitMessageLbl.visible     = true
          accountingBalanceBeginnigMessageLbl.text    = accountingPopupObject.errorMessage
          accountingBalanceBeginnigMessageLbl.visible = true
          accountingReportDataMessageLbl.text         = accountingPopupObject.errorMessage
          accountingReportDataMessageLbl.visible      = true
          accountingWriteOffMessageLbl.text           = accountingPopupObject.errorMessage
          accountingWriteOffMessageLbl.visible        = true

          errorCounter += 7
        } else {
            if(accountingProviderTF.text.length === 0) {
                accountingProviderMessageLbl.text    = accountingPopupObject.errorMessage
                accountingProviderMessageLbl.visible = true
                ++errorCounter
            } else {
              accountingProviderMessageLbl.visible = false
            }

            if(productCategoryCB.displayText === "") {
                accountingProductCategoryMessageLbl.text    = accountingPopupObject.errorSelectMessage
                accountingProductCategoryMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingProductCategoryMessageLbl.visible = false
            }

            if(productCB.displayText === "") {
                accountingProductMessageLbl.text    = accountingPopupObject.errorSelectMessage
                accountingProductMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingProductMessageLbl.visible = false
            }

            if(productUnitCB.displayText === "") {
                accountingProductUnitMessageLbl.text    = accountingPopupObject.errorSelectMessage
                accountingProductUnitMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingProductUnitMessageLbl.visible = false
            }

            if(accountingBalanceBeginningTF.text.length === 0) {
                accountingBalanceBeginnigMessageLbl.text    = accountingPopupObject.errorMessage
                accountingBalanceBeginnigMessageLbl.visible = true
                ++errorCounter
            } else if(parsefloat(accountingBalanceBeginningTF.text) <= 0) {
                accountingBalanceBeginnigMessageLbl.text    = accountingPopupObject.errorNullMessage
                accountingBalanceBeginnigMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingBalanceBeginnigMessageLbl.visible = false
            }

            if(accountingReportDataTF.text.length === 0) {
                accountingReportDataMessageLbl.text    = accountingPopupObject.errorMessage
                accountingReportDataMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(accountingReportDataTF.text) <= 0){
                accountingReportDataMessageLbl.text    = accountingPopupObject.errorNullMessage
                accountingReportDataMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingReportDataMessageLbl.visible = false
            }

            if(accountingWriteOffTF.text.length === 0) {
                accountingWriteOffMessageLbl.text    = accountingPopupObject.errorMessage
                accountingWriteOffMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(accountingWriteOffTF.text) <= 0) {
                accountingWriteOffMessageLbl.text    = accountingPopupObject.errorNullMessage
                accountingWriteOffMessageLbl.visible = true
                ++errorCounter
            } else {
                accountingWriteOffMessageLbl.visible = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }


            ColumnLayout {
                anchors.fill: parent

                Label {
                    text: "Введите данные для учёта"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                }

                MenuSeparator{Layout.fillWidth: true}

                TextField {
                    id: accountingProviderTF
                    placeholderText: "Введите название поставщика"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    selectByMouse: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: TextInput.AlignHCenter
                }

                Label {
                    id: accountingProviderMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                Label {
                    text: "Выберите категорию продукции"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                }

                ComboBox {
                    id: productCategoryCB
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                }

                Label {
                    id: accountingProductCategoryMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                Label {
                    text: "Выберите продукцию"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                }

                ComboBox {
                    id: productCB
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                }

                Label {
                    id: accountingProductMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                Label {
                    text: "Выберите единицу измерения"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                }

                ComboBox {
                    id: productUnitCB
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                }

                Label {
                    id: accountingProductUnitMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                TextField {
                    id: accountingBalanceBeginningTF
                    placeholderText: "Введите остаток на начало"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    selectByMouse: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: TextInput.AlignHCenter
                }

                Label {
                    id: accountingBalanceBeginnigMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                TextField {
                    id: accountingReportDataTF
                    placeholderText: "Введите данные отчета"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    selectByMouse: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: TextInput.AlignHCenter
                }

                Label {
                    id: accountingReportDataMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }
                TextField {
                    id: accountingWriteOffTF
                    placeholderText: "Введите данные списания"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    selectByMouse: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: TextInput.AlignHCenter
                }

                Label {
                    id: accountingWriteOffMessageLbl
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    color: accountingPopupObject.errorColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                    horizontalAlignment: Text.AlignHCenter
                    visible: false
                }

                Button {
                    id: addBtn
                    text: "Добавить"
                    font.family: accountingPopupObject.fontFamily
                    font.pointSize: accountingPopupObject.fontPointSize
                    highlighted: true
                    Layout.preferredWidth: parent.width
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: addingAccountingData()
                }
            }
}
