import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Layouts 1.15


Page {
    id: mainPageRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height
    title: "Главная"

    QtObject {
        id: mainPageObject
        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property int imgParamsWidthHeight: 90
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
        property double oneTwentyPart: 1/20
        property int minMainWindowHeigt: 480
        property int sevenHundredFourtyWindowHeight: 740
    }

    Grid {
        id: mainPageGrid
        anchors.fill: parent
        columns: 3

        Rectangle {
            id: purchaseMainPageRect
            width: mainPageRoot.width * mainPageObject.oneThirdPart
            height: mainPageRoot.height >= mainPageObject.minMainWindowHeigt && mainPageRoot.height <= mainPageObject.onSecondPart?
                        mainPageRoot.height * mainPageObject.oneThirdPart :  mainPageRoot.height * mainPageObject.oneSecondPart

            Column {
                width: parent.width
                height: parent.height

                Image {
                    id: purchaseImageBtn
                    source: "../resources/button_img/purchase_img.png"
                    width: mainPageObject.imgParamsWidthHeight
                    height: mainPageObject.imgParamsWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainTabButton.text      = "Закупки"
                            mainTabButton.height    = window.height * mainPageObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            purchasePage.visible    = true
                        }
                    }
                }

                Label {
                    id: purchaseLbl
                    text: "Закупки"
                    font.family: mainPageObject.fontFamily
                    font.pointSize: mainPageObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: categoriesMainPageRect
            width: mainPageRoot.width * mainPageObject.oneThirdPart
            height: mainPageRoot.height >= mainPageObject.minMainWindowHeigt && mainPageRoot.height <= mainPageObject.onSecondPart?
                        mainPageRoot.height * mainPageObject.oneThirdPart :  mainPageRoot.height * mainPageObject.oneSecondPart

            Column {
                width: parent.width
                height: parent.height

                Image {
                    id: categoriesImage
                    source: "../resources/button_img/category.png"
                    width: mainPageObject.imgParamsWidthHeight
                    height: mainPageObject.imgParamsWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            mainTabButton.text      = "Категории"
                            mainTabButton.height    = window.height * mainPageObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            categoryPage.visible    = true
                        }
                    }
                }

                Label {
                    id: categoryLbl
                    text: "Категории товара"
                    font.family: mainPageObject.fontFamily
                    font.pointSize: mainPageObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: accountingMainPageRect
            width: mainPageRoot.width * mainPageObject.oneThirdPart
            height: mainPageRoot.height >= mainPageObject.minMainWindowHeigt && mainPageRoot.height <= mainPageObject.onSecondPart?
                        mainPageRoot.height * mainPageObject.oneThirdPart :  mainPageRoot.height * mainPageObject.oneSecondPart

            Column {
                width: parent.width
                height: parent.height

                Image {
                    id: accountingImage
                    source: "../resources/button_img/accounting.png"
                    width: mainPageObject.imgParamsWidthHeight
                    height: mainPageObject.imgParamsWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            mainTabButton.text      = "Учёт"
                            mainTabButton.height    = window.height * mainPageObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            accountingPage.visible  = true
                        }
                    }
                }

                Label {
                    id: accountingLbl
                    text: "Учёт"
                    font.family: mainPageObject.fontFamily
                    font.pointSize: mainPageObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: unitsMainPageRect
            width: mainPageRoot.width * mainPageObject.oneThirdPart
            height: mainPageRoot.height >= mainPageObject.minMainWindowHeigt && mainPageRoot.height <= mainPageObject.onSecondPart?
                        mainPageRoot.height * mainPageObject.oneThirdPart :  mainPageRoot.height * mainPageObject.oneSecondPart

            Column {
                width: parent.width
                height: parent.height

                Image {
                    id: unitsImage
                    source: "../resources/button_img/units.png"
                    width: mainPageObject.imgParamsWidthHeight
                    height: mainPageObject.imgParamsWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainTabButton.text      = "Единицы измерения"
                            mainTabButton.width     = window.height * mainPageObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            unitsPage.visible       = true
                        }
                    }
                }

                Label {
                    text: "Единицы измерения"
                    font.family: mainPageObject.fontFamily
                    font.pointSize: mainPageObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    PurchasePage {id: purchasePage; width: window.width; height: window.height; visible: false}
    CategoryPage {id:categoryPage; width: window.width; height: window.height; visible: false }
    AccountingPage{id: accountingPage; width: window.width; height: window.height; visible: false}
    UnitsPage{id: unitsPage; width: window.width; height: window.height; visible: false}
}
