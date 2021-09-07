import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.2

import "common"

Page {
    id: reportsRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height

    QtObject {
        id: reportsObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int fontPointSize: 10
        property string textColor: "black"
        property string errorColor: "red"
        property string successColor: "green"
        property double sevenPercet: 0.07
        property double tenPercent: 0.1
        property double fifteenPercent: 0.15
        property double fiftyPercent: 0.5
        property double sixtyPercent: 0.6
        property double sixtySevenPercent:  0.67
        property double minWindowHeight: 480
        property double sevenHundredFourtyHeight: 740
        property double oneSecondPart: 1/2
        property double oneThirdPartWidth: 1/3
        property double oneFourthPartWidth: 1/4
        property int imageWidthHeight: 50
        property int borderWidth: 1
        property string borderColor: "gray"
        property string enteryDateText:  "Выберите входную дату"
        property string finalDateText: "Выберите конечную дату закупки"
    }

    function addingReportsData() {
        if(checkSelectData()) {
            reportsModel.addReportData(enteryDateLbl.text, finalDateLbl.text, reportsModel.getProviderStatistic(enteryDateLbl.text, finalDateLbl.text))
            calendarItem.manualCheckDate = ""
            calendarItem.rangeDate       = ""
        }
    }

    function checkSelectData() {
        var errorCounter = 0
        if(enteryDateLbl.text === reportsObject.enteryDateText && finalDateLbl.text === reportsObject.finalDateText) {
            enteryDateLbl.color = reportsObject.errorColor
            finalDateLbl.color  = reportsObject.errorColor
            errorCounter += 2
        } else {
            if(enteryDateLbl.text === reportsObject.enteryDateText) {
                enteryDateLbl.color = reportsObject.errorColor
                ++errorCounter
            } else {
                enteryDateLbl.color = reportsObject.successColor
            }

            if(finalDateLbl.text === reportsObject.finalDateText) {
                finalDateLbl.color = reportsObject.errorColor
                ++errorCounter
            } else {
                finalDateLbl.color = reportsObject.successColor
            }
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    Rectangle {
        id: topSideReportsRect
        width: parent.width
        height: reportsRoot.height >= reportsObject.minWindowHeight && reportsRoot.height <= reportsObject.sevenHundredFourtyHeight?
                    reportsRoot.height * reportsObject.fifteenPercent: reportsRoot.height * reportsObject.tenPercent

        Rectangle {
            id: returnToPurchasePageRect
            width: parent.width * reportsObject.oneThirdPartWidth
            height: parent.height

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/turn_left.png"
                    width: reportsObject.imageWidthHeight
                    height: reportsObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea{
                        anchors.fill: parent
                        onClicked:  {
                            mainTabButton.text      = "Закупки"
                            mainTabButton.height    = window.height * reportsObject.oneThirdPartWidth
                            stack.currentItem.title = mainTabButton.text
                            reportsPage.visible     = false
                        }
                    }
                }

                Label {
                    text: "Закупки"
                    font.family: reportsObject.fontFamily
                    font.pointSize: reportsObject.fontPointSize
                    color: reportsObject.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: calendarRect
            width: parent.width * reportsObject.oneThirdPartWidth
            height: parent.height
            anchors.left: returnToPurchasePageRect.right

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/calendar_icon.png"
                    width: reportsObject.imageWidthHeight
                    height: reportsObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked:  {
                            calendarDialog.open()
                        }
                    }
                }

                Label {
                    text: "Календарь"
                    font.family: reportsObject.fontFamily
                    font.pointSize: reportsObject.fontPointSize
                    color: reportsObject.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: calculatorRect
            width: parent.width * reportsObject.oneThirdPartWidth
            height: parent.height
            anchors.left: calendarRect.right

            Column {
                width: parent.width
                height: parent.height

                Image {
                    source: "../resources/button_img/calculator.png"
                    width: reportsObject.imageWidthHeight
                    height: reportsObject.imageWidthHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent

                        onClicked: addingReportsData()
                    }
                }

                Label {
                    text: "Посчитать"
                    font.family: reportsObject.fontFamily
                    font.pointSize: reportsObject.fontPointSize
                    color: reportsObject.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Rectangle {
        id: selectedDateRect
        width: parent.width
        height: parent.height * reportsObject.tenPercent
        anchors.top: topSideReportsRect.bottom

        RowLayout {
            width: parent.width
            height: parent.height

            Label {
                id: enteryDateLbl
                text: calendarItem.manualCheckDate? calendarItem.manualCheckDate : reportsObject.enteryDateText
                font.family: reportsObject.fontFamily
                font.pointSize: reportsObject.fontPointSize
                color: reportsObject.textColor
                Layout.leftMargin: parent.width * reportsObject.fifteenPercent
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: parent.width * reportsObject.oneSecondPart
            }

            Label {
                id: finalDateLbl
                text: calendarItem.rangeDate? calendarItem.rangeDate: reportsObject.finalDateText
                font.family: reportsObject.fontFamily
                font.pointSize: reportsObject.fontPointSize
                color: reportsObject.textColor
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: parent.width * reportsObject.oneSecondPart
            }
        }
    }


    Rectangle {
        id: contentReportsRect
        width: parent.width
        height: reportsRoot.height >= reportsObject.minWindowHeight && reportsRoot.height <= reportsObject.sevenHundredFourtyHeight?
                    reportsRoot.height * reportsObject.fiftyPercent : reportsRoot.height * reportsObject.sixtySevenPercent
        anchors.top: selectedDateRect.bottom

        ListModel {
            id: reportsModel

            ListElement {
                entery_date: "20.08.2021"
                final_date: "27.08.2021"
                provider: "Константин"
                pruchase_sum: 10000
            }
        }

        ListView {
            id: reportsListView
            anchors.fill: parent

            model: reportsModel

            clip: true

            headerPositioning: ListView.OverlayHeader

            ScrollBar.vertical: reportsVerticalSB

            header: Rectangle {
                id: mainContentRect
                width: reportsListView.width
                height: reportsListView.height * reportsObject.tenPercent

                Rectangle {
                    id: enteryDateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: "Начало закупки"
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: finalDateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: enteryDateRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: "Конец закупки"
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: providerReportsRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: finalDateRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: "Поставщик"
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: purchaseSumReportsRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: providerReportsRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: "Общая сумма"
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            delegate: Rectangle {
                id: mainReportsDelegateRect
                width: reportsListView.width
                height: reportsRoot.height >= reportsObject.minWindowHeight && reportsRoot.height <= reportsObject.sevenHundredFourtyHeight?
                            reportsListView.height * reportsObject.tenPercent : reportsListView.height * reportsObject.sevenPercet

                Rectangle {
                    id: enteryDateDelegateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: model.entery_date
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: finalDateDelegateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: enteryDateDelegateRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: model.final_date
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: providerReportsDelegateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: finalDateDelegateRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: model.provider
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: purchaseSumReportsDelegateRect
                    width: parent.width * reportsObject.oneFourthPartWidth
                    height: parent.height
                    anchors.left: providerReportsDelegateRect.right
                    border.width: reportsObject.borderWidth
                    border.color: reportsObject.borderColor

                    Label {
                        text: model.pruchase_sum
                        font.family: reportsObject.fontFamily
                        font.pointSize: reportsObject.fontPointSize
                        color: reportsObject.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: reportsMenu.open()
                }

                Menu {
                    id: reportsMenu
                    anchors.centerIn: parent

                    MenuItem {
                        text: "Удалить"
                        onClicked:  {
                            reportsObject.chooseIndex = index
                            messageBox.info           = "Вы действительно хотите удалить?"
                            messageBox.open()
                        }
                    }
                }
            }
        }

        ScrollBar {
            id: reportsVerticalSB
            hoverEnabled: true
            active: hovered || pressed
            size: reportsListView.height
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    MessageBox {
        id: messageBox
        x: parent.width * reportsObject.oneSecondPart - width * reportsObject.oneSecondPart
        y: parent.height * reportsObject.oneSecondPart - height * reportsObject.oneSecondPart
        onOkClicked: reportsModel.removeReportData(reportsObject.chooseIndex)
    }

    Dialog {
        id: calendarDialog
        width: calendarItem.calendarWidth
        height: calendarItem.calendarHeight

        contentItem: CalendarItem {id: calendarItem}
    }
}
