import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: storeRoot
    width: 450
    height: 450

    modal: true
    focus: true

    QtObject {
        id: storeObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string errorSelectMessage: "Выберите значение"
        property string errorPriceMessage: "Цена не может быть меньше или равна нулю"
        property double oneSecondPart: 1/2
    }

    function addingStoreData() {
        if(checkInputData()) {
            productsModel.addProductData(providerCB.displayText, categoryCB.displayText,
                                         productTF.text, parseFloat(priceTF.text), productUnitCB.displayText)
            productTF.clear()
            priceTF.clear()
            storeRoot.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0
        if(providerCB.displayText === "" && categoryCB.displayText === "" &&
           productTF.text.length === 0 && productUnitCB.displayText === "" &&
           priceTF.text.length === 0) {
            providerStoreMessageLbl.text        = storeObject.errorSelectMessage
            providerStoreMessageLbl.visible     = true
            categoryStoreMessageLbl.text        = storeObject.errorSelectMessage
            categoryStoreMessageLbl.visible     = true
            productStoreMessageLbl.text         = storeObject.errorMessage
            productStoreMessageLbl.visible      = true
            productStoreMessageLbl.text         = storeObject.errorMessage
            productStoreMessageLbl.visible      = true
            productUnitStoreMessageLbl.text     = storeObject.errorMessage
            productUnitStoreMessageLbl.visible  = true
            priceStoreMessageLbl.text           = storeObject.errorMessage
            priceStoreMessageLbl.visible        = true
            errorCounter += 5
        } else {
            if(providerCB.displayText === "") {
                providerStoreMessageLbl.text        = storeObject.errorSelectMessage
                providerStoreMessageLbl.visible     = true
                ++errorCounter
            } else {
               providerStoreMessageLbl.visible = false
            }

            if(categoryCB.displayText === "") {
                categoryStoreMessageLbl.text    = storeObject.errorSelectMessage
                categoryStoreMessageLbl.visible = true
                ++errorCounter
            } else {
                categoryStoreMessageLbl.visible = false
            }

            if(productTF.text.length === 0) {
                productStoreMessageLbl.text    = storeObject.errorMessage
                productStoreMessageLbl.visible = true
                ++errorCounter
            } else {
                productStoreMessageLbl.visible = false
            }

            if(productUnitCB.displayText === "") {
                productUnitStoreMessageLbl.text     = storeObject.errorSelectMessage
                productUnitStoreMessageLbl.visible  = true
                ++errorCounter
            } else {
                productUnitStoreMessageLbl.visible  = false
            }

            if(priceTF.text.length === 0) {
                priceStoreMessageLbl.text    = storeObject.errorMessage
                priceStoreMessageLbl.visible = true
                ++errorCounter
            } else if(parseFloat(priceTF.text) <= 0) {
                priceStoreMessageLbl.text    = storeObject.errorPriceMessage
                priceStoreMessageLbl.visible = true
                ++errorCounter
            } else {
                priceStoreMessageLbl.visible = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed:  {
      providerStoreMessageLbl.visible    = false
      categoryStoreMessageLbl.visible    = false
      productStoreMessageLbl.visible     = false
      productUnitStoreMessageLbl.visible = false
      priceStoreMessageLbl.visible       = false
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Введите данные о продукции"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            font.bold: true
            color: storeObject.textColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * storeObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
        }

        MenuSeparator {Layout.fillWidth: true}

        Label {
            text: "Выберите поставщика"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            font.bold: true
            color: storeObject.textColor
        }

        ComboBox {
            id: providerCB
            model: providersModel
            textRole: "provider"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: providerStoreMessageLbl
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            color: storeObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * storeObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Label {
            text: "Выберите категорию товара"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            font.bold: true
            color: storeObject.textColor
        }

        ComboBox {
            id: categoryCB
            model: categoriesModel
            textRole: "product_category"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: categoryStoreMessageLbl
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            color: storeObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * storeObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        TextField {
            id: productTF
            placeholderText: "Введите название продукции"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator{regExp: /[А-Яа-я]+/}
        }

        Label {
            id: productStoreMessageLbl
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            color: storeObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * storeObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Label {
            text: "Выберите единицу измерения"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            font.bold: true
            color: storeObject.textColor
        }

        ComboBox {
            id: productUnitCB
            textRole: "unit"
            model: unitsModel
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: productUnitStoreMessageLbl
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            color: storeObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * storeObject.oneSecondPart
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        TextField {
            id: priceTF
            placeholderText: "Введите цену реализации"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            selectByMouse: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator {regExp: /^([0-9]+\.[0-9]+)$/}
        }

        Label {
            id: priceStoreMessageLbl
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            color: storeObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Button {
            id: addBtn
            text: "Добавить"
            font.family: storeObject.fontFamily
            font.pointSize: storeObject.fontPointSize
            highlighted: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            onClicked: addingStoreData()
        }
    }
}
