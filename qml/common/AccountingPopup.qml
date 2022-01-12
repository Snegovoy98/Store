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
        property string borderColor: "gray"
        property int borderWidth: 3
        property double oneSecondPart: 1/2
        property bool isFirstBalanceBeginningValue: false
        property double tenPercent: 0.1
        property double fourtyPercent: 0.4
        property double fiftyPercent: 0.5
        property double ninetyPercent: 0.9
        property double balanceBeginningValue: 0
    }

    function applyFilters() {
        if(checkSelectedValues()) {
            selectedElementsRect.visible                = false
            columnLayout.visible                        = false
            inputValuesRect.visible                     = true
            accountingPopupObject.balanceBeginningValue = accountingModel.getBalanceBeginningValue(providerCB.displayText, categoryCB.displayText,
                                                                                                   productCB.displayText, productUnitCB.displayText)
        }
    }

    function checkSelectedValues() {
        var selectedValuesErrorCounter = 0

        if(providerCB.displayText === "" && categoryCB.displayText === "" &&
                productCB.displayText  === "" && productUnitCB.displayText === "") {
            providerMessageLbl.text       = accountingPopupObject.errorSelectMessage
            providerMessageLbl.visible    = true
            categoryMessageLbl.text       = accountingPopupObject.errorSelectMessage
            categoryMessageLbl.visible    = true
            productMessageLbl.text        = accountingPopupObject.errorSelectMessage
            productMessageLbl.visible     = true
            productUnitMessageLbl.text    = accountingPopupObject.errorSelectMessage
            productUnitMessageLbl.visible = true

            selectedValuesErrorCounter += 4
        } else {
            if(providerCB.displayText === "") {
                providerMessageLbl.text    = accountingPopupObject.errorSelectMessage
                providerMessageLbl.visible = true
                ++selectedValuesErrorCounter
            } else {
                providerMessageLbl.visible = false
            }

            if(categoryCB.displayText === "") {
                categoryMessageLbl.text     = accountingPopupObject.errorSelectMessage
                categoryMessageLbl.visible  = true
                ++selectedValuesErrorCounter
            } else {
                categoryMessageLbl.visible  = false
            }

            if(productCB.displayText  === "") {
                productMessageLbl.text    = accountingPopupObject.errorSelectMessage
                productMessageLbl.visible = true
                ++selectedValuesErrorCounter
            } else {
                productMessageLbl.visible = false
            }

            if(productUnitCB.displayText === "") {
                productUnitMessageLbl.text    = accountingPopupObject.errorSelectMessage
                productUnitMessageLbl.visible = true
                ++selectedValuesErrorCounter
            } else {
                productUnitMessageLbl.visible = false
            }
        }

        if(!productsModel.isEqualSelectedValues(providerCB.displayText, categoryCB.displayText,
                                                productCB.displayText, productUnitCB.displayText)) {
            notEqualMessageLbl.visible = true
            ++selectedValuesErrorCounter
        } else {
            notEqualMessageLbl.visible = false
        }

        if(selectedValuesErrorCounter === 0)
            return true
        else
            return false
    }

    function addAccountingData() {
        if(checkInputData()) {
            accountingModel.addAccountingData(providerCB.displayText, categoryCB.displayText, productCB.displayText,
                                              productUnitCB.displayText, balanceBeginningTf.text, reportDataTf.text, writeOffTf.text)
            balanceBeginningTf.clear()
            reportDataTf.clear()
            writeOffTf.clear()

            accountingPopup.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0
        if(balanceBeginningTf.text.length === 0 && reportDataTf.text.length === 0 && writeOffTf.text.length === 0) {
            balanceBeginningMessageLbl.text    = accountingPopupObject.errorMessage
            balanceBeginningMessageLbl.visible = true
            reportDataMessageLbl.text          = accountingPopupObject.errorMessage
            reportDataMessageLbl.visible       = true
            writeOffMessageLbl.text            = accountingPopupObject.errorMessage
            writeOffMessageLbl.visible         = true
        } else {
            if(balanceBeginningTf.text.length === 0) {
                balanceBeginningMessageLbl.text    = accountingPopupObject.errorMessage
                balanceBeginningMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(balanceBeginningTf.text) <= 0) {
                balanceBeginningMessageLbl.text    = accountingPopupObject.errorNullMessage
                balanceBeginningMessageLbl.visible = true
                ++errorCounter
            } else {
                balanceBeginningMessageLbl.visible = false
            }

            if(reportDataTf.text.length === 0) {
                reportDataMessageLbl.text    = accountingPopupObject.errorMessage
                reportDataMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(reportDataTf.text) <= 0) {
                reportDataMessageLbl.text    = accountingPopupObject.errorNullMessage
                reportDataMessageLbl.visible = true
                ++errorCounter
            } else {
                reportDataMessageLbl.visible = false
            }

            if(writeOffTf.text.length === 0) {
                writeOffMessageLbl.text     = accountingPopupObject.errorMessage
                writeOffMessageLbl.visible  = true
                ++errorCounter
            } else if(parseFloat(writeOffTf.text) <= 0) {
                writeOffMessageLbl.text     = accountingPopupObject.errorNullMessage
                writeOffMessageLbl.visible  = true
                ++errorCounter
            } else {
              writeOffMessageLbl.visible  = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed: {
        selectedElementsRect.visible       = true
        columnLayout.visible               = true
        inputValuesRect.visible            = false
        providerMessageLbl.visible         = false
        categoryMessageLbl.visible         = false
        productMessageLbl.visible          = false
        productUnitMessageLbl.visible      = false
        balanceBeginningMessageLbl.visible = false
        reportDataMessageLbl.visible       = false
        writeOffMessageLbl.visible         = false
    }

    RowLayout {
        id: rowLayout
        width: parent.width
        height: parent.height * accountingPopupObject.tenPercent

        ColumnLayout {
            width: parent.width
            height: parent.height

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
        }
    }

    Rectangle {
        id: selectedElementsRect
        width: parent.width
        height: parent.height * accountingPopupObject.fiftyPercent
        border.color: accountingPopupObject.borderColor
        border.width: accountingPopupObject.borderWidth
        anchors.top: rowLayout.bottom
        Layout.alignment: Qt.AlignHCenter

        ColumnLayout {
            id: leftSelectedElementsSide
            width: parent.width * accountingPopupObject.oneSecondPart
            height: parent.height

            Label {
                text: "Выберите поставщика"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.textColor
            }

            ComboBox {
                id: providerCB
                model: providersModel
                textRole: "provider"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            }

            Label {
                id: providerMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }


            Label {
                text: "Выберите продукцию"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.textColor
            }

            ComboBox {
                id: productCB
                model: productsModel
                textRole: "product"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            }

            Label {
                id: productMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }
        }

        ColumnLayout {
            id: rightSelectedElementsSide
            width: parent.width * accountingPopupObject.oneSecondPart
            height: parent.height
            anchors.left: leftSelectedElementsSide.right

            Label {
                text: "Выберите категорию товара"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.textColor
            }

            ComboBox {
                id: categoryCB
                model: categoriesModel
                textRole: "product_category"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            }

            Label {
                id: categoryMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }


            Label {
                text: "Выберите единицу измерения"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.textColor
            }

            ComboBox {
                id: productUnitCB
                model: unitsModel
                textRole: "unit"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            }

            Label {
                id: productUnitMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
                horizontalAlignment: Text.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        width: parent.width
        height: parent.height * accountingPopupObject.tenPercent
        anchors.top: selectedElementsRect.bottom

        Label {
            id: notEqualMessageLbl
            text: "Выбраны неверные значения"
            font.family: accountingPopupObject.fontFamily
            font.pointSize: accountingPopupObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            color: accountingPopupObject.errorColor
            visible: false
        }

        Button {
            id: applyBtn
            text: "Применить"
            font.family: accountingPopupObject.fontFamily
            font.pointSize: accountingPopupObject.fontPointSize
            highlighted: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * accountingPopupObject.oneSecondPart
            onClicked: applyFilters()
        }
    }

    Rectangle {
        id: inputValuesRect
        width: parent.width
        height: parent.height * accountingPopupObject.fiftyPercent
        border.color: accountingPopupObject.borderColor
        border.width: accountingPopupObject.borderWidth
        anchors.top: rowLayout.bottom
        Layout.alignment: Qt.AlignHCenter
        visible: false

        ColumnLayout {
            id: inputColumnLayout
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter

            TextField {
                id: balanceBeginningTf
                text: accountingPopupObject.balanceBeginningValue
                placeholderText: "Введите данные остатка на начало"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                readOnly: accountingPopupObject.balanceBeginningValue !== 0? true : false
                validator: RegExpValidator{regExp: /^([0-9]+\.[0-9]+)$/}
            }

            Label {
                id: balanceBeginningMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }
            TextField {
                id: reportDataTf
                placeholderText: "Введите данные отчета"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                validator: RegExpValidator{regExp: /^([0-9]+\.[0-9]+)$/}
            }

            Label {
                id: reportDataMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }

            TextField {
                id: writeOffTf
                placeholderText: "Введите данные списания"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                validator: RegExpValidator{regExp: /^([0-9]+\.[0-9]+)$/}
            }

            Label {
                id: writeOffMessageLbl
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: TextInput.AlignHCenter
                color: accountingPopupObject.errorColor
                visible: false
            }
        }

        RowLayout {
            width: parent.width
            height: parent.height
            anchors.top:  inputColumnLayout.bottom

            Button {
                id: addBtn
                text: "Добавить"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.fiftyPercent
                onClicked: addAccountingData()

            }
            Button {
                id: cancelBtn
                text: "Отмена"
                font.family: accountingPopupObject.fontFamily
                font.pointSize: accountingPopupObject.fontPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width * accountingPopupObject.fiftyPercent
                onClicked: {
                    selectedElementsRect.visible = true
                    columnLayout.visible         = true
                    inputValuesRect.visible      = false
                }
            }
        }
    }
}
