import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.2

Popup {
    id: root
    width: 450
    height: 350

    modal: true

    QtObject {
        id: addingPurchaseDataObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string errorProviderMessage: "Выберите поставщика"
        property double oneSecondPart: 1/2
        property int imageWidthHeight: 50
        property string defaultText: "Выберите дату закупки"
        property double tenPercent: 0.1
        property string product_value: ""
        property double price_value: 0
    }

    function addingPurchaseData() {
        if(checkInputData()) {
            purchaseModel.addPurchaseData(selectedDate.text, providerCB.displayText, addingPurchaseDataObject.product_value,
                                          addingPurchaseDataObject.price_value, weightPurchaseTF.text)

            selectedDate.text = addingPurchaseDataObject.defaultText
            productPurchaseTF.clear();
            weightPurchaseTF.clear();
            root.close()
        }

    }

    function checkInputData() {
        var errorCounter = 0
        if(selectedDate.text === "Выберите дату закупки" && providerCB.currentText === "" &&
                productPurchaseTF.text.length === 0 && productUnitPurchaseTF.text.length === 0) {
            selectedDate.color                  = addingPurchaseDataObject.errorColor
            providerPurchaseMessageLbl.text     = addingPurchaseDataObject.errorProviderMessage
            providerPurchaseMessageLbl.visible  = true
            productPurchaseMessageLbl.text      = addingPurchaseDataObject.errorMessage
            productPurchaseMessageLbl.visible   = true
            weightMessageLbl.text          = addingPurchaseDataObject.errorMessage
            weightMessageLbl.visible       = true
            errorCounter += 4
        } else {
            if(selectedDate.text === "Выберите дату закупки") {
                selectedDate.color = addingPurchaseDataObject.errorColor
                ++errorCounter
            } else {
                selectedDate.color = addingPurchaseDataObject.textColor
                selectedDate.text  = ""
            }

            if(providerCB.currentText === "") {
                providerPurchaseMessageLbl.text     = addingPurchaseDataObject.errorProviderMessage
                providerPurchaseMessageLbl.visible  = true
                ++errorCounter
            } else {
                providerPurchaseMessageLbl.visible  = false
            }

            if(productPurchaseTF.text.length === 0) {
                productPurchaseMessageLbl.text    = addingPurchaseDataObject.errorMessage
                productPurchaseMessageLbl.visible = true
                ++errorCounter
            } else {
                productPurchaseMessageLbl.visible = false
            }

            if(weightPurchaseTF.text.length === 0) {
                weightMessageLbl.text    = addingPurchaseDataObject.errorMessage
                weightMessageLbl.visible = true
                ++errorCounter
            } else {
                weightMessageLbl.visible  = false
            }

            if(errorCounter === 0)
                return true
            else
                return false
        }
    }

    onClosed: {
        providerPurchaseMessageLbl.visible = false
        productPurchaseMessageLbl.visible  = false
        weightMessageLbl.visible      = false
    }

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent

        Label {
            text: "Форма закупок"
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            color: addingPurchaseDataObject.textColor
        }

        MenuSeparator {Layout.fillWidth: true}

        Image {
            id: calendarLogo
            source: "../../resources/button_img/calendar_icon.png"
            width: addingPurchaseDataObject.imageWidthHeight
            height: addingPurchaseDataObject.imageWidthHeight
            Layout.alignment: Qt.AlignHCenter

            MouseArea {
                anchors.fill: parent
                onClicked: calendarDialog.open()
            }
        }

        Label {
            id: selectedDate
            text: calendarItem.manualCheckDate !== ""? calendarItem.manualCheckDate: addingPurchaseDataObject.defaultText
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            color: addingPurchaseDataObject.textColor
        }

        ComboBox {
            id: providerCB
            model: providersModel
            textRole: "provider"
            Layout.preferredWidth: parent.width
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            onSelectTextByMouseChanged: purchaseFilterModel.setProviderData(providerCB.displayText)
        }

        Label {
            id: providerPurchaseMessageLbl
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            color: addingPurchaseDataObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            visible: false
        }

        TextField {
            id: productPurchaseTF
            placeholderText: "Введите название продукции"
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator {regExp: /[А-Яа-я]+/}
            onTextChanged: {
                purchaseFilterModel.setProductData(productPurchaseTF.text)

                if(productPurchaseTF.text.length !== 0)
                    contentLV.visible = true
                else
                    contentLV.visible = false
            }
        }

        ListView {
            id: contentLV
            width: 200
            height: 200
            visible: false
            Layout.alignment: Qt.AlignHCenter
            model: purchaseFilterModel

            ScrollBar.vertical: lvVerticalSB

            header: Rectangle {
                width: contentLV.width
                height: contentLV.height * addingPurchaseDataObject.tenPercent

                Rectangle {
                    id: leftPartTitleRect
                    width: parent.width * addingPurchaseDataObject.oneSecondPart
                    height: parent.height

                    Label {
                        id: productTitleLbl
                        text: "Продукция"
                        font.family: addingPurchaseDataObject.fontFamily
                        font.pointSize: addingPurchaseDataObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: rightPartTitleRect
                    width: parent.width * addingPurchaseDataObject.oneSecondPart
                    height: parent.height
                    anchors.left: leftPartTitleRect.right

                    Label {
                        id: priceTitleLbl
                        text: "Цена"
                        font.family: addingPurchaseDataObject.fontFamily
                        font.pointSize: addingPurchaseDataObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            delegate: Rectangle {
                id: mainContentRect
                width: contentLV.width
                height: contentLV.height * addingPurchaseDataObject.tenPercent

                Rectangle {
                    id: leftPartDataRect
                    width: parent.width * addingPurchaseDataObject.oneSecondPart
                    height: parent.height

                    Label {
                        id: productDataLbl
                        text: providerCB.displayText === model.provider? model.product : ""
                        font.family: addingPurchaseDataObject.fontFamily
                        font.pointSize: addingPurchaseDataObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle {
                    id: rightPartDataRect
                    width: parent.width * addingPurchaseDataObject.oneSecondPart
                    height: parent.height
                    anchors.left: leftPartDataRect.right

                    Label {
                        id: priceDataLbl
                        text: providerCB.displayText === model.provider? model.price: ""
                        font.family: addingPurchaseDataObject.fontFamily
                        font.pointSize: addingPurchaseDataObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        addingPurchaseDataObject.product_value = productDataLbl.text
                        addingPurchaseDataObject.price_value   = priceDataLbl.text
                        productPurchaseTF.text = addingPurchaseDataObject.product_value + ", " + addingPurchaseDataObject.price_value
                        contentLV.visible = false
                    }
                }
            }
        }

        Label {
            id: productPurchaseMessageLbl
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            color: addingPurchaseDataObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            visible: false
        }

        TextField {
            id: weightPurchaseTF
            placeholderText: "Введите вес товара"
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            color: addingPurchaseDataObject.textColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            validator: RegExpValidator{regExp: /^([0-9]+\.[0-9]+)$/}
        }

        Label {
            id: weightMessageLbl
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            color: addingPurchaseDataObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            visible: false
        }

        Button {
            id: addBtn
            text: "Добавить"
            font.family: addingPurchaseDataObject.fontFamily
            font.pointSize: addingPurchaseDataObject.fontPointSize
            highlighted: true
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            onClicked: addingPurchaseData()
        }

        Dialog {
            id: calendarDialog
            width: calendarItem.calendarWidth
            height: calendarItem.calendarHeight
            contentItem: CalendarItem{id: calendarItem}
        }
    }

    ScrollBar {
        id: lvVerticalSB
        hoverEnabled: true
        active: hovered || pressed
        size: contentLV.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
