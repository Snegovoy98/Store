import QtQuick 2.15
import QtQuick.Controls 2.15
import "common"

Page {
    id: unitsPageRoot

    QtObject {
        id: unitsPageObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int btnTitlePointSize: 12
        property int fontPointSize: 14
        property string textColor: "black"
        property string errorColor: "red"
        property int imageWithHeight: 50
        property double tenPercent: 0.1
        property double fifteenPercent: 0.15
        property double ninetyPercent: 0.9
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
        property int minMainWindowHeigt: 480
        property int sevenHundredFourtyWindowHeight: 740
    }

    Rectangle {
        id: topSideRect
        width: unitsPageRoot.width
        height: unitsPageRoot.height >= unitsPageObject.minMainWindowHeigt && unitsPageRoot.height <= unitsPageObject.sevenHundredFourtyWindowHeight?
                    unitsPageRoot.height * unitsPageObject.fifteenPercent : unitsPageRoot.height * unitsPageObject.tenPercent

        Rectangle {
            width: parent.width * unitsPageObject.oneSecondPart
            height: parent.height

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/turn_left.png"
                    width: unitsPageObject.imageWithHeight
                    height: unitsPageObject.imageWithHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainTabButton.text      = "Главная"
                            mainTabButton.height    = window.height * unitsPageObject.oneThirdPart
                            stack.currentItem.title = mainTabButton.text
                            unitsPage.visible       = false
                        }
                    }
                }

                Label {
                    text: "Главная"
                    font.family: unitsPageObject.fontFamily
                    font.pointSize: unitsPageObject.btnTitlePointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    GridView {
        id: unitsGV
        width: parent.width
        height: parent.height * unitsPageObject.ninetyPercent
        anchors.top: topSideRect.bottom

        model: unitsModel

        clip: true

        ScrollBar.vertical: unitSB

        cellWidth: width * unitsPageObject.oneSecondPart
        cellHeight: height * unitsPageObject.tenPercent

        delegate: unitsComponent

        ScrollBar {
            id: unitSB
            hoverEnabled: true
            active: hovered || pressed
            size: unitsGV.height * unitsPageObject.oneSecondPart
            anchors.top: unitsGV.top
            anchors.right: unitsGV.right
            anchors.bottom: unitsGV.bottom
        }
    }

    Component {
        id: unitsComponent

        Rectangle {
            id: mainRect
            width: unitsGV.cellWidth
            height: unitsGV.cellHeight

            Label {
                id: unitLbl
                text: model.unit
                font.family: unitsPageObject.fontFamily
                font.pointSize: unitsPageObject.fontPointSize
                font.bold: true
                color: unitsPageObject.textColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: unitsMenu.open()
            }

            Menu {
                id: unitsMenu
                anchors.centerIn: parent

                MenuItem {
                    text: "Редактировать"
                    onClicked: {
                        unitEditingPopup.old_unit_value = unitLbl.text
                        unitEditingPopup.open()
                    }
                }

                MenuSeparator {}

                MenuItem {
                    text: "Удалить"
                    onClicked: {
                        unitsPageObject.chooseIndex = index
                        messageBox.info             = "Вы действительно хотите удалить?"
                        messageBox.open()
                    }
                }
            }
        }
    }


    UnitEditingPopup {
        id: unitEditingPopup
        x: parent.width * unitsPageObject.oneSecondPart - width * unitsPageObject.oneSecondPart
        y: parent.height * unitsPageObject.oneSecondPart - height * unitsPageObject.oneSecondPart
        onOkClicked: unitsModel.updateUnit(unitEditingPopup.new_unit_value, unitEditingPopup.old_unit_value)
    }

    MessageBox {
        id: messageBox
        x: parent.width * unitsPageObject.oneSecondPart - width * unitsPageObject.oneSecondPart
        y: parent.height * unitsPageObject.oneSecondPart - height * unitsPageObject.oneSecondPart
        onOkClicked: unitsModel.removeUnit(unitsPageObject.chooseIndex)
    }
}
