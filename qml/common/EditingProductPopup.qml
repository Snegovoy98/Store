import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: productEditingRoot
    width: 400
    height: 350

    modal: true
    focus: true

    signal okClicked()

    property string provider: ""
    property string new_product_value: ""
    property double new_price_value: 0
    property string old_product_value: ""
    property double old_price_value: 0

    function editingProductData() {
        if(checkInputData()) {
            new_product_value      = productEditingTf.text
            new_price_value        = priceEditingTf.text
            okClicked()
            productEditingRoot.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0
        if(productEditingTf.text.length === 0 && priceEditingTf.text.length === 0) {
            productEditingMessageLbl.text    = productEditingObject.errorMessage
            priceEditingMessageLbl.text      = productEditingObject.errorMessage
            productEditingMessageLbl.visible = true
            priceEditingMessageLbl.visible   = true
            errorCounter += 3
        } else {
            if(productEditingTf.text.length === 0) {
                productEditingMessageLbl.text    = productEditingObject.errorMessage
                productEditingMessageLbl.visible = true
                ++errorCounter
            } else {
                productEditingMessageLbl.visible = false
            }

            if(priceEditingTf.text.length === 0) {
                priceEditingMessageLbl.text      = productEditingObject.errorMessage
                priceEditingMessageLbl.visible   = true
                ++errorCounter
            } else if(parseFloat(priceEditingTf.text) <= 0) {
                priceEditingMessageLbl.text      = productEditingObject.priceValueMessage
                priceEditingMessageLbl.visible   = true
                ++errorCounter
            } else {
                priceEditingMessageLbl.visible   = false
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    QtObject {
        id: productEditingObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string borderColor: "#5D76CB"
        property int borderWidth: 1
        property double oneSecondPart: 1/2
        property string errorMessage: "Поле не может быть пустым"
        property string priceValueMessage: "Цена не может быть меньше или равно нулю"
        property string errorColor: "red"
        property string textColor: "black"
    }

    onClosed: {
        productEditingMessageLbl.visible = false;
        priceEditingMessageLbl.visible   = false;
        productUnitMessageLbl.visible    = false;
        productEditingTf.text            = old_product_value
        priceEditingTf.text              = old_price_value
    }

    Rectangle {
        id: mainRectangle
        anchors.fill: parent
        border.width: productEditingObject.borderWidth
        border.color: productEditingObject.borderColor
        radius: 5

        ColumnLayout {
            id: editingProductColumn
            width: parent.width
            height: parent.height

            Label {
                text: "Продукция"
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                color: productEditingObject.textColor
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: productEditingTf
                text: old_product_value
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                Layout.preferredWidth: parent.width * productEditingObject.oneSecondPart
                Layout.alignment: Qt.AlignHCenter
                selectByMouse: true
                horizontalAlignment: TextInput.Center
                validator: RegExpValidator{regExp: /[А-Яа-я]+/}
            }

            Label {
                id: productEditingMessageLbl
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                color: productEditingObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                visible: false
            }

            Label {
                text: "Цена"
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                color: productEditingObject.textColor
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: priceEditingTf
                text: old_price_value
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                Layout.preferredWidth: parent.width * productEditingObject.oneSecondPart
                Layout.alignment: Qt.AlignHCenter
                selectByMouse: true
                horizontalAlignment: TextInput.Center
                validator: RegExpValidator{regExp: /^([0-9]+\.[0-9]+)$/}
            }

            Label {
                id: priceEditingMessageLbl
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                color: productEditingObject.errorColor
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                id: editingBtn
                text: "Редактировать"
                font.family: productEditingObject.fontFamily
                font.pointSize: productEditingObject.fontPointSize
                highlighted: true
                Layout.preferredWidth: parent.width * productEditingObject.oneSecondPart
                Layout.alignment: Qt.AlignHCenter
                onClicked: editingProductData()
            }
        }
    }
}
