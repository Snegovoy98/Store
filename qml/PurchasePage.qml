import QtQuick 2.15
import QtQuick.Controls 2.15

import "common"

Page {
    id: purchaseRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height

    QtObject {
        id: purchaseObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int fontPointSize: 10
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
        property double oneFifthPart: 1/5
        property double oneSixthPart: 1/6
        property double oneSeventhPart: 1/7
        property double oneNinthPart: 1/9
        property double sevenPercent: 0.07
        property double tenPercent: 0.1
        property double fifteenPercent: 0.15
        property double sixtyPercent: 0.6
        property double seventySevenPercent: 0.77
        property double ninetyPercent: 0.9
        property int imageWidthHeight: 50
        property double minWindowHeight: 480
        property double sevenHundredFourtyHeight: 740
        property string textColor: "black"
        property int borderWidth: 1
        property string borderColor: "gray"
    }

    Rectangle {
        id: topSideRect
        width: parent.width
        height: purchaseRoot.height >= purchaseObject.minWindowHeight && purchaseRoot.height <= purchaseObject.sevenHundredFourtyHeight?
                    parent.height * purchaseObject.fifteenPercent : parent.height * purchaseObject.tenPercent

        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: returnToMainPageRect
            width: parent.width * purchaseObject.oneThirdPart
            height: parent.height

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/turn_left.png"
                    width: purchaseObject.imageWidthHeight
                    height: purchaseObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainTabButton.text      = "Главная"
                            mainTabButton.height    = window.height * purchaseObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            purchaseRoot.visible    = false
                        }
                    }
                }

                Label {
                    text: "Главная"
                    font.family: purchaseObject.fontFamily
                    font.pointSize: purchaseObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: purchaseObject.textColor
                }
            }
        }

        Rectangle {
            id: addingPurchaseDataRect
            width: parent.width * purchaseObject.oneThirdPart
            height: parent.height
            anchors.left: returnToMainPageRect.right

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/purchase_list.png"
                    width: purchaseObject.imageWidthHeight
                    height: purchaseObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: addingPurchaseDataPopup.open()
                    }
                }

                Label {
                    text: "Добавить данные о закупке"
                    font.family: purchaseObject.fontFamily
                    font.pointSize: purchaseObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: purchaseObject.textColor
                }
            }
        }

        Rectangle {
            id: reportsRect
            width: parent.width * purchaseObject.oneThirdPart
            height: parent.height
            anchors.left: addingPurchaseDataRect.right

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/purchase_report.png"
                    width: purchaseObject.imageWidthHeight
                    height: purchaseObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            mainTabButton.text      = "Отчеты"
                            mainTabButton.height    = window.height * purchaseObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            reportsPage.visible     = true
                        }
                    }
                }

                Label {
                    text: "Отчеты"
                    font.family: purchaseObject.fontFamily
                    font.pointSize: purchaseObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: purchaseObject.textColor
                }
            }
        }
    }

    Rectangle {
        id: contentSideRect
        width: parent.width
        height: purchaseRoot.height >= purchaseObject.minWindowHeight && purchaseRoot.height <= purchaseObject.seventySevenPercent?
                    parent.height * purchaseObject.sixtyPercent : parent.height * purchaseObject.seventySevenPercent
        anchors.top: topSideRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        ListView {
            id: purchaseListView
            anchors.fill: parent

            clip: true

            model: purchaseModel

            headerPositioning: ListView.OverlayHeader

            ScrollBar.vertical: verticalPurhcaseSB

            header: Rectangle {
                id: mainHeaderRect
                width: purchaseListView.width
                height: purchaseListView.height * purchaseObject.tenPercent


                Rectangle {
                    id: purchaseDateHeaderRect
                    width: parent.width * purchaseObject.oneSeventhPart
                    height: parent.height
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "Дата закупки"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }

                Rectangle {
                    id: purchaseProviderHeaderRect
                    width: parent.width * purchaseObject.oneSixthPart
                    height: parent.height
                    anchors.left: purchaseDateHeaderRect.right
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "Поставщик"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }

                Rectangle {
                    id: purchaseProductHeaderRect
                    width: parent.width * purchaseObject.oneSixthPart
                    height: parent.height
                    anchors.left: purchaseProviderHeaderRect.right
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "Продукция"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }

                Rectangle {
                    id: purchasePriceHeaderRect
                    width: parent.width * purchaseObject.oneNinthPart
                    height: parent.height
                    anchors.left: purchaseProductHeaderRect.right
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "Цена"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }

                Rectangle {
                    id: purchaseProductUnitHeaderRect
                    width: parent.width * purchaseObject.oneFifthPart
                    height: parent.height
                    anchors.left: purchasePriceHeaderRect.right
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "кг/л/шт"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }

                Rectangle {
                    id: productSumHeaderRect
                    width: parent.width * purchaseObject.oneFifthPart
                    height: parent.height
                    anchors.left: purchaseProductUnitHeaderRect.right
                    border.width: purchaseObject.borderWidth
                    border.color: purchaseObject.borderColor

                    Label {
                        text: "Поставлено товара"
                        font.family: purchaseObject.fontFamily
                        font.pointSize: purchaseObject.fontPointSize
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: purchaseObject.textColor
                    }
                }
            }
             delegate: Rectangle {
                 id: contentLVRect
                 width: purchaseListView.width
                 height: purchaseRoot.height >= purchaseObject.minWindowHeight && purchaseRoot.height <= purchaseObject.sevenHundredFourtyHeight?
                             purchaseListView.height * purchaseObject.tenPercent : purchaseListView.height * purchaseObject.sevenPercent

                 Rectangle {
                     id: purchaseDateRect
                     width: parent.width * purchaseObject.oneSeventhPart
                     height: parent.height
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.purchase_date
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 Rectangle {
                     id: purchaseProviderRect
                     width: parent.width * purchaseObject.oneSixthPart
                     height: parent.height
                     anchors.left: purchaseDateRect.right
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.provider
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 Rectangle {
                     id: purchaseProductRect
                     width: parent.width * purchaseObject.oneSixthPart
                     height: parent.height
                     anchors.left: purchaseProviderRect.right
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.product
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 Rectangle {
                     id: purchasePriceRect
                     width: parent.width * purchaseObject.oneNinthPart
                     height: parent.height
                     anchors.left: purchaseProductRect.right
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.price
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 Rectangle {
                     id: purchaseProductUnitRect
                     width: parent.width * purchaseObject.oneFifthPart
                     height: parent.height
                     anchors.left: purchasePriceRect.right
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.weight
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 Rectangle {
                     id: productSumRect
                     width: parent.width * purchaseObject.oneFifthPart
                     height: parent.height
                     anchors.left: purchaseProductUnitRect.right
                     border.width: purchaseObject.borderWidth
                     border.color: purchaseObject.borderColor

                     Label {
                         text: model.delivered_goods
                         font.family: purchaseObject.fontFamily
                         font.pointSize: purchaseObject.fontPointSize
                         anchors.horizontalCenter: parent.horizontalCenter
                         anchors.verticalCenter: parent.verticalCenter
                         color: purchaseObject.textColor
                     }
                 }

                 MouseArea {
                     anchors.fill: parent
                     acceptedButtons: Qt.RightButton
                     onClicked: purchaseMenu.open()
                 }

                 Menu {
                     id: purchaseMenu
                     anchors.centerIn: parent

                     MenuItem {
                         text: "Удалить"
                         onClicked: {
                             purchaseObject.chooseIndex = index
                             messageBox.info            = "Вы действительно хотите удалить?"
                             messageBox.open()
                         }
                     }
                 }
             }
        }

        ScrollBar {
            id: verticalPurhcaseSB
            hoverEnabled: true
            active: hovered || pressed
            size: purchaseListView.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    MessageBox {
        id: messageBox
        x: parent.width * purchaseObject.oneSecondPart - width * purchaseObject.oneSecondPart
        y: parent.height * purchaseObject.oneSecondPart - height * purchaseObject.oneSecondPart
        onOkClicked: purchaseModel.removePurchaseData(purchaseObject.chooseIndex)
    }

    AddingPurchaseDataPopup {
        id: addingPurchaseDataPopup
        x: parent.width * purchaseObject.oneSecondPart - width * purchaseObject.oneSecondPart
        y: parent.height * purchaseObject.oneSecondPart - height * purchaseObject.oneSecondPart
    }

    ReportsPage {
        id: reportsPage
        width: window.width
        height: window.height
        visible: false
    }
}
