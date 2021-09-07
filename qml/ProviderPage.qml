import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.2

import "common"

Page{
    id: providerPageRoot
    width: ApplicationWindow.width
    height: ApplicationWindow.height

    QtObject {
        id: providerPageObject

        property int chooseIndex: 0
        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property int informationPS: 7
        property int borderWidth: 1
        property string borderColor: "gray"
        property double oneThirdPart: 1/3
        property double oneTwoPart: 1/2
        property int imageWidthHeightParam: 50
        property string textColor: "black"
        property string old_provider_name: ""
        property string old_phone_number: ""
        property string old_email_value: ""
    }

    Component {
        id: delegateComponent

        Rectangle {
            id: componentRect
            width: providerGridView.cellWidth
            height: providerGridView.cellHeight
            border.width: providerPageObject.borderWidth
            border.color: providerPageObject.borderColor
            radius: 5

            Column {
                id: topColumn
                width: parent.width
                height: parent.height * providerPageRoot.height * providerPageObject.oneTwoPart

                Image {
                    id: logoImage
                    width: providerPageObject.imageWidthHeightParam
                    height: providerPageObject.imageWidthHeightParam
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: model.provider_image_path? model.provider_image_path : "../resources/button_img/default_picture.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: fileDialog.open()
                    }
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: imageRect
                    }
                }

                FileDialog {
                    id: fileDialog
                    title: "Выберите изображение"
                    folder: shortcuts.home
                    nameFilters: ["Image files: (*.jpg, *.png, *.jpeg)", "All files(*)"]
                    onAccepted: providersModel.setProviderLogo(providerNameLbl.text, fileDialog.fileUrl)
                }
                Rectangle {
                    id: imageRect
                    width: providerPageObject.imageWidthHeightParam
                    height: providerPageObject.imageWidthHeightParam
                    radius: 250
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: false
                }

                Label {
                    id: providerNameLbl
                    text: model.provider
                    font.family: providerPageObject.fontFamily
                    font.pointSize: providerPageObject.fontPointSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: providerPageObject.textColor

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onClicked: editingProviderMenu.open()
                    }

                    Menu {
                        id: editingProviderMenu
                        anchors.centerIn: parent
                        MenuItem {
                            text: "Редактировать"
                            onClicked: {
                                providerPageObject.old_provider_name = providerNameLbl.text
                                providerPageObject.old_phone_number  = phoneLbl.text
                                providerPageObject.old_email_value   = emailLbl.text
                                editingProviderPopup.provider        = providerPageObject.old_provider_name
                                editingProviderPopup.phone           = providerPageObject.old_phone_number
                                editingProviderPopup.email           = providerPageObject.old_email_value
                                editingProviderPopup.open()
                            }
                        }

                        MenuSeparator{}

                        MenuItem {
                            text: "Удалить"
                            onClicked: {
                                providerPageObject.chooseIndex = index
                                messageBox.info = "Вы действительно хотите удалить?"
                                messageBox.open()


                            }
                        }
                    }
                }
            }

            Column {
                id: bottomColumn
                width: parent.width
                height: parent.height * providerPageObject.oneThirdPart
                anchors.bottom: parent.bottom
                Label {
                    id: contactInfoLbl
                    text: "Контактная информация"
                    font.family: providerPageObject.fontFamily
                    font.pointSize: providerPageObject.informationPS
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: providerPageObject.textColor
                }

                Label {
                    id: phoneLbl
                    text: model.phone
                    font.family: providerPageObject.fontFamily
                    font.pointSize: providerPageObject.informationPS
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: providerPageObject.textColor
                }

                Label {
                    id: emailLbl
                    text: model.email
                    font.family: providerPageObject.fontFamily
                    font.pointSize: providerPageObject.informationPS
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: providerPageObject.textColor
                }
            }
        }
    }

    GridView {
        id: providerGridView
        anchors.fill: parent
        cellWidth: width * providerPageObject.oneThirdPart
        cellHeight: height * providerPageObject.oneThirdPart
        model: providersModel
        delegate: delegateComponent
    }


    MessageBox {
        id: messageBox
        x: parent.width * providerPageObject.oneTwoPart - width * providerPageObject.oneTwoPart
        y: parent.height * providerPageObject.oneTwoPart - height * providerPageObject.oneTwoPart
        onOkClicked: providersModel.removeProvider(providerPageObject.chooseIndex)
    }

    EditingProviderPopup {
        id: editingProviderPopup
        x: parent.width * providerPageObject.oneTwoPart - width * providerPageObject.oneTwoPart
        y: parent.height * providerPageObject.oneTwoPart - height * providerPageObject.oneTwoPart
        onOkClicked: providersModel.editProviderData(providerPageObject.old_provider_name, editingProviderPopup.provider,
                                                     providerPageObject.old_phone_number, editingProviderPopup.phone,
                                                     providerPageObject.old_email_value, editingProviderPopup.email)
    }
}
