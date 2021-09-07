import QtQuick 2.15
import QtQuick.Controls 2.15

import "common"

Page {
    id: categoryRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height

    QtObject {
        id: categoryObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int btnFontPointSize: 12
        property int fontPointSize: 14
        property string textColor: "black"
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
        property double tenPercent: 0.1
        property double fifteenPercent: 0.15
        property double ninetyPercent: 0.9
        property int imageWidthHeight: 50
        property int minMainWindowHeigt: 480
        property int sevenHundredFourtyWindowHeight: 740
    }

    Rectangle {
        id: btnRect
        width: parent.width
        height: categoryRoot.height >= categoryObject.minMainWindowHeigt && categoryRoot.height <= categoryObject.sevenHundredFourtyWindowHeight?
                categoryRoot.height * categoryObject.fifteenPercent : categoryRoot.height * categoryObject.tenPercent

        Rectangle {
            id: returnToMainPageRect
            width: parent.width * categoryObject.oneSecondPart
            height: parent.height

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/turn_left.png"
                    width: categoryObject.imageWidthHeight
                    height: categoryObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainTabButton.text      = "Главная"
                            mainTabButton.height    = window.height * categoryObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            categoryRoot.visible    = false
                        }
                    }
                }

                Label {
                    text: "Главная"
                    font.family: categoryObject.fontFamily
                    font.pointSize: categoryObject.btnFontPointSize
                    color: categoryObject.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    GridView {
        id: categoryGridView
        width: parent.width
        height: parent.height * categoryObject.ninetyPercent
        anchors.top: btnRect.bottom

        cellWidth: width * categoryObject.oneSecondPart
        cellHeight: height * categoryObject.tenPercent

        model: categoriesModel
        clip: true

        ScrollBar.vertical: categoryVerticalSB

        delegate: categoryComponent


        ScrollBar {
            id: categoryVerticalSB
            hoverEnabled: true
            active: hovered || pressed
            size: categoryGridView.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

    }

    Component {
        id: categoryComponent

        Rectangle {
            width: categoryGridView.cellWidth
            height: categoryGridView.cellHeight

            Label {
                id: categoryValueLbl
                text: model.product_category
                font.family: categoryObject.fontFamily
                font.pointSize: categoryObject.fontPointSize
                font.bold: true
                color: categoryObject.textColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: categoryMenu.open()
            }

            Menu {
                id: categoryMenu
                anchors.centerIn: parent

                MenuItem {
                    text: "Редактировать"
                    onClicked: {
                        categoryEdititngPopup.old_category_value = categoryValueLbl.text
                        categoryEdititngPopup.open()
                    }
                }

                MenuSeparator {}

                MenuItem {
                    text: "Удалить"
                    onClicked: {
                        categoryObject.chooseIndex = index
                        messageBox.info            = "Вы действительно хотите удалить?"
                        messageBox.open()
                    }
                }
            }
        }
    }

    CategoryEditingPopup {
        id: categoryEdititngPopup
        x: parent.width * categoryObject.oneSecondPart - width * categoryObject.oneSecondPart
        y: parent.height * categoryObject.oneSecondPart - height * categoryObject.oneSecondPart
        onOkClicked: categoriesModel.updateCategory(categoryEdititngPopup.old_category_value, categoryEdititngPopup.new_category_value)
    }

    MessageBox {
        id: messageBox
        x: parent.width * categoryObject.oneSecondPart - width * categoryObject.oneSecondPart
        y: parent.height * categoryObject.oneSecondPart - height * categoryObject.oneSecondPart
        onOkClicked: categoriesModel.removeCategory(categoryObject.chooseIndex)
    }

}
