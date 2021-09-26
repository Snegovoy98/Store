import QtQuick 2.15
import QtQuick.Controls 2.15

import "common"

Page {
    id: accountingRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height


    QtObject {
        id: accountingObject

        property string fontFamily: "Decorative"
        property int btnTitlePointSize: 12
        property int titleHeaderPointSize: 7
        property int fontPointSize: 14
        property string color: "black"
        property int borderWidth: 1
        property string borderColor: "black"
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
        property double oneSixthPart: 1/6
        property double oneSeventhPart: 1/7
        property double oneEightPart: 1/8
        property double oneTenPart: 1/10
        property double tenPercent: 0.1
        property double fifteenPercent: 0.15
        property double sixtyPercent: 0.6
        property double eightyPercent: 0.8
        property int minWindowHeight: 480
        property int sevenHundredFourtyHeight: 740
        property int imageWidthHeight: 50
    }

    Rectangle {
        id: accountingBtnRect
        width: parent.width
        height: accountingRoot.height >= accountingObject.minWindowHeight && accountingRoot.height <= accountingObject.sevenHundredFourtyHeight?
                    accountingRoot.height * accountingObject.fifteenPercent : accountingRoot.height * accountingObject.tenPercent

        Rectangle {
            id: returnToMainPageRect
            width: parent.width * accountingObject.oneSecondPart
            height: parent.height

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/turn_left.png"
                    width: accountingObject.imageWidthHeight
                    height: accountingObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            mainTabButton.text      = "Главная"
                            mainTabButton.height    = window.height * accountingObject.oneThirdPart
                            stack.currentItem.title =  mainTabButton.text
                            accountingRoot.visible  = false
                        }
                    }
                }

                Label {
                    text: "Главная"
                    font.family: accountingObject.fontFamily
                    font.pointSize: accountingObject.btnTitlePointSize
                    color: accountingObject.color
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: addingAccountingDataRect
            width: parent.width * accountingObject.oneSecondPart
            height: parent.height
            anchors.left: returnToMainPageRect.right

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/accounting_data.png"
                    width: accountingObject.imageWidthHeight
                    height: accountingObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: accountingPopup.open()
                    }
                }

                Label {
                    text: "Добавить данные для учёта"
                    font.family: accountingObject.fontFamily
                    font.pointSize: accountingObject.btnTitlePointSize
                    color: accountingObject.color
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Rectangle {
        id: accountingContentRect
        width: parent.width
        height: accountingRoot.height >= accountingObject.minWindowHeight && accountingRoot.height <= accountingObject.sevenHundredFourtyHeight?
                    accountingRoot.height * accountingObject.sixtyPercent : accountingRoot.height * accountingObject.eightyPercent

        anchors.top: accountingBtnRect.bottom

        ListView {
            id: accountingListView
            anchors.fill: parent

            model: accountingModel
            clip: true

            ScrollBar.vertical: accountingVerticalSB

            headerPositioning: ListView.OverlayHeader

            header:  Rectangle {
                id: mainAccountingHeaderRect
                width: accountingListView.width
                height: accountingListView.height * accountingObject.fifteenPercent

                Rectangle {
                    id: accontingProviderHeaderRect
                    width: parent.width * accountingObject.oneTenPart
                    height:  parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor

                    Label {
                        text: "Поставщик"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: accountingCategoryHeaderRect
                    width: parent.width * accountingObject.oneSeventhPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accontingProviderHeaderRect.right

                    Label {
                        text: "Категория товара"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: accountingProductHeaderRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingCategoryHeaderRect.right

                    Label {
                        text: "Продукция"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingProductUnitHeaderRect
                    width: parent.width * accountingObject.oneSeventhPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingProductHeaderRect.right

                    Label {
                        text: "Единица измерения"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingBalanceBeginningHeaderRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingProductUnitHeaderRect.right

                    Label {
                        text: "Остаток на начало"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingReportDataHeaderRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingBalanceBeginningHeaderRect.right

                    Label {
                        text: "Данные отчета"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingWriteOffHeaderRect
                    width: parent.width * accountingObject.oneTenPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingReportDataHeaderRect.right

                    Label {
                        text: "Списание"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingFinalBalanceHeaderRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingWriteOffHeaderRect.right

                    Label {
                        text: "Остаток на конец"
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            delegate: Rectangle {
                id: mainContentDelegateRect
                width: accountingListView.width
                height: accountingListView.height * accountingObject.tenPercent

                Rectangle {
                    id: accontingProviderContentRect
                    width: parent.width * accountingObject.oneTenPart
                    height:  parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor

                    Label {
                        id: accontingProviderContentLbl
                        text: model.provider
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: accountingCategoryContentRect
                    width: parent.width * accountingObject.oneSeventhPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accontingProviderContentRect.right

                    Label {
                        id: accountingCategoryContentLbl
                        text: model.product_category
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: accountingProductContentRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingCategoryContentRect.right

                    Label {
                        id: accountingProductContentLbl
                        text: model.product
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingProductUnitContentRect
                    width: parent.width * accountingObject.oneSeventhPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingProductContentRect.right

                    Label {
                        id: accountingProductUnitContentLbl
                        text: model.product_unit
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingBalanceBeginningContentRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingProductUnitContentRect.right

                    Label {
                        id: accountingBalanceBeginningContentLbl
                        text: model.balance_beginning
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingReportDataContentRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingBalanceBeginningContentRect.right

                    Label {
                        id: accountingReportDataContentLbl
                        text: model.report_data
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingWriteOffContentRect
                    width: parent.width * accountingObject.oneTenPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingReportDataContentRect.right

                    Label {
                        id: accountingWriteOffContentLbl
                        text: model.write_off
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: accountingFinalBalanceContentRect
                    width: parent.width * accountingObject.oneEightPart
                    height: parent.height
                    border.width: accountingObject.borderWidth
                    border.color: accountingObject.borderColor
                    anchors.left: accountingWriteOffContentRect.right

                    Label {
                        text: model.final_balance
                        font.family: accountingObject.fontFamily
                        font.pointSize: accountingObject.titleHeaderPointSize
                        color: accountingObject.color
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: accountingMenu.open()
                }

                Menu {
                    id: accountingMenu
                    anchors.centerIn: parent

                    MenuItem {
                        text: "Редактировать"
                        onClicked: {
                            accountingEditingPopup.provider                    = accontingProviderContentLbl.text
                            accountingEditingPopup.category                    = accountingCategoryContentLbl.text
                            accountingEditingPopup.product                     = accountingProductContentLbl.text
                            accountingEditingPopup.product_unit                = accountingProductUnitContentLbl.text
                            accountingEditingPopup.old_balance_beginning_value = accountingBalanceBeginningContentLbl.text
                            accountingEditingPopup.old_report_data_value       = accountingReportDataContentLbl.text
                            accountingEditingPopup.old_write_off_data_value    = accountingWriteOffContentLbl.text
                            accountingEditingPopup.isFirstBalanceBeginningValue = accountingModel.isFirstBalanceBeginning(accontingProviderContentLbl.text,
                                                                                                                          accountingCategoryContentLbl.text,
                                                                                                                          accountingProductContentLbl.text,
                                                                                                                          accountingProductUnitContentLbl.text,
                                                                                                                          accountingBalanceBeginningContentLbl.text,
                                                                                                                          accountingEditingPopup)
                            accountingEditingPopup.open()
                        }
                    }
                }
            }
            ScrollBar {
                id: accountingVerticalSB
                hoverEnabled: true
                active: hovered || pressed
                size: accountingListView.height
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
    }

    Connections {
        target: providersModel

        function onProviderDataChanged() {
            accountingModel.updateProviderData()
        }

    }

    Connections {
        target: categoriesModel

        function onCategoryChangedValue() {
            accountingModel.updateCategoryData()
        }
    }

    Connections {
        target: productsModel

        function onProductUpdated() {
            accountingModel.updateProductData()
        }
    }

    AccountingPopup {
        id: accountingPopup
        x: parent.width * accountingObject.oneSecondPart - width * accountingObject.oneSecondPart
        y: parent.height * accountingObject.oneSecondPart - height * accountingObject.oneSecondPart
    }
    AccountingEditingPopup {
        id: accountingEditingPopup
        x: parent.width * accountingObject.oneSecondPart - width * accountingObject.oneSecondPart
        y: parent.height * accountingObject.oneSecondPart - height * accountingObject.oneSecondPart
    }
}
