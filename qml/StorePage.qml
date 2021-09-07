import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12
import QtQuick.Layouts 1.12

import "common"

Page {
    id: storeRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height

    QtObject {
        id: storeObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string provider_name: ""
        property string old_prod_name: ""
        property double old_price: 0
        property double oneSecondPart: 1/2
        property double oneFourthValue: 1/4
        property double sevenPercent: 0.07
        property double seventyPercent: 0.7
        property double nintyFivePercent: 0.95
        property string textColor: "black"
    }

   ListView {
        id: storeLV
        anchors.fill: parent

        model: productsModel

        spacing: 15

        ScrollBar.vertical: productPageVerticalScrollBar

        delegate: Rectangle {
            id: mainRectangle
            width: storeRoot.width
            height: storeRoot.height * storeObject.sevenPercent


            Rectangle {
                id: productStoreRect
                width: mainRectangle.width * storeObject.oneFourthValue
                height: mainRectangle.height * storeObject.oneFourthValue


                Label {
                    id: productStoreLbl
                    text: model.product
                    width: parent.width
                    font.family: storeObject.fontFamily
                    font.pointSize: storeObject.fontPointSize
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: storeObject.textColor
                }
            }

            Rectangle {
                id: priceStoreRect
                width: mainRectangle.width * storeObject.oneFourthValue
                height: mainRectangle.height * storeObject.oneFourthValue
                anchors.left: productStoreRect.right

                Label {
                    id: priceStoreLbl
                    text: model.price
                    width: parent.width
                    font.family: storeObject.fontFamily
                    font.pointSize: storeObject.fontPointSize
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: storeObject.textColor
                }
            }

            Rectangle {
                id: categoryStoreRect
                width: mainRectangle.width * storeObject.oneFourthValue
                height: mainRectangle.height * storeObject.oneFourthValue
                anchors.left: priceStoreRect.right

                Label {
                    id: categoryStoreLbl
                    text: model.category
                    width: parent.width
                    font.family: storeObject.fontFamily
                    font.pointSize: storeObject.fontPointSize
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: storeObject.textColor
                }
            }

            Rectangle {
                id: productUnitStoreRect
                width: mainRectangle.width * storeObject.oneFourthValue
                height: mainRectangle.height * storeObject.oneFourthValue
                anchors.left: categoryStoreRect.right

                Label {
                    id: productUnitStoreLbl
                    text: model.product_unit
                    width: parent.width
                    font.family: storeObject.fontFamily
                    font.pointSize: storeObject.fontPointSize
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: storeObject.textColor
                }
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton

                onClicked: storeMenu.open()
            }

            Menu {
                id: storeMenu
                anchors.centerIn: parent

                MenuItem {
                    text: "Редактировать"
                    onClicked: {
                        editingProductPopup.provider                = provider
                        editingProductPopup.old_product_value       = product
                        editingProductPopup.old_price_value         = price
                        editingProductPopup.old_product_unit_value  = product_unit

                        editingProductPopup.open()
                    }
                }

                MenuSeparator {}

                MenuItem {
                    text: "Удалить"
                    onClicked: {
                        storeObject.chooseIndex = index
                        messageBox.info = "Вы действительно хотите удалить?"
                        messageBox.open()
                    }
                }
            }
        }

        section.property: "provider"
        section.criteria: ViewSection.FullString
        section.delegate: productComponent
    }



    Component {
        id: productComponent
        Rectangle {
            id: prodCompRect
            width: storeRoot.width
            height: 70

            required property string section

            Text {
                id: parentSection
                width: parent.width
                text: " Поставщик: " + parent.section
                font.bold: true
                font.family: storeObject.fontFamily
                font.pointSize: storeObject.fontPointSize
                color: storeObject.textColor
                horizontalAlignment: TextInput.AlignHCenter
            }


            Rectangle {
                id: titleRectangle
                width: storeRoot.width
                anchors.top:  parentSection.bottom
                Rectangle {
                    id: productTitleRectangle
                    width: parent.width * storeObject.oneFourthValue
                    Text {
                        id: productText
                        width: parent.width
                        text: "Продукция"
                        font.family: storeObject.fontFamily
                        font.pointSize: storeObject.fontPointSize
                        horizontalAlignment: Qt.AlignHCenter
                        color: storeObject.textColor
                    }
                }

                Rectangle {
                    id: priceTitleRectangle
                    width: parent.width * storeObject.oneFourthValue
                    anchors.left: productTitleRectangle.right
                    Text {
                        id: priceText
                        width: parent.width
                        text: "Цена"
                        font.family: storeObject.fontFamily
                        font.pointSize: storeObject.fontPointSize
                        horizontalAlignment: Qt.AlignHCenter
                        color: storeObject.textColor
                    }
                }

                Rectangle {
                    id: categoryTitleRectangle
                    width: parent.width * storeObject.oneFourthValue
                    anchors.left: priceTitleRectangle.right
                    Text {
                        id: categoryText
                        width: parent.width
                        text: "Категория товара"
                        font.family: storeObject.fontFamily
                        font.pointSize: storeObject.fontPointSize
                        horizontalAlignment: Qt.AlignHCenter
                        color: storeObject.textColor
                    }
                }

                Rectangle {
                    id: productInitTitleRectangle
                    width: parent.width * storeObject.oneFourthValue
                    anchors.left: categoryTitleRectangle.right
                    Text {
                        id: productUnitText
                        width: parent.width
                        text: "Единицы измерения"
                        font.family: storeObject.fontFamily
                        font.pointSize: storeObject.fontPointSize
                        horizontalAlignment: Qt.AlignHCenter
                        color: storeObject.textColor
                    }
                }
            }
        }
    }

    ScrollBar {
        id: productPageVerticalScrollBar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Vertical
        size: storeLV.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    MessageBox {
        id: messageBox
        x: parent.width * storeObject.oneSecondPart - width * storeObject.oneSecondPart
        y: parent.height * storeObject.oneSecondPart - height * storeObject.oneSecondPart
        onOkClicked: productsModel.removeProductData(storeObject.chooseIndex)
    }

    EditingProductPopup {
        id: editingProductPopup
        x: parent.width * storeObject.oneSecondPart - width * storeObject.oneSecondPart
        y: parent.height * storeObject.oneSecondPart - height * storeObject.oneSecondPart
        onOkClicked: productsModel.updateProductData(editingProductPopup.provider, editingProductPopup.new_product_value,
                                                     editingProductPopup.new_price_value, editingProductPopup.new_product_unit_value,
                                                     editingProductPopup.old_product_value, editingProductPopup.old_price_value,
                                                     editingProductPopup.old_product_unit_value)
    }

    Connections {
        target: providersModel
        function onProviderDeleted() {
            productsModel.update()
        }

        function onProviderDataChanged() {
            productsModel.updateProductValue()
        }
    }

    Connections {
        target: categoriesModel

        function onCategoryChangedValue() {
            productsModel.updateProductValue()
        }
    }
}


