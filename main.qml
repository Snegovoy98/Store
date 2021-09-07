import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

import "./qml"
import "./qml/common"


ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Store")

    Universal.theme: mainWindowObject.isLightTheme? Universal.System: Universal.Dark
    Universal.accent: Universal.Teal

    QtObject {
        id: mainWindowObject
        property bool isLightTheme: true
        property double oneSecondPart: 1/2
        property double oneThirdPart: 1/3
    }

    header: ToolBar {
        id: headerToolBar
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "\u22EE"
                font.pointSize: 26
                onClicked: contextMenuTheme.open()

                Menu {
                    id:contextMenuTheme
                    MenuItem {
                        text: !mainWindowObject.isLightTheme? "Light theme" : "Dark theme"
                        onTriggered: mainWindowObject.isLightTheme? mainWindowObject.isLightTheme = false :
                                                                    mainWindowObject.isLightTheme = true
                    }
                }
            }

            Label {
                id: titleLbl
                text: stack.currentItem.title
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                id: addBtn
                text: "+"
                font.pointSize: 24
                onClicked: contextMenuAdd.open()

                Menu {
                    id: contextMenuAdd
                    x: -200
                    y: 30

                    MenuItem {
                        text: "Добавить поставщика"
                        onClicked: providerPopup.open()
                    }

                    MenuSeparator{}

                    MenuItem {
                        text: "Добавить категорию"
                        onClicked: categoryPopup.open()
                    }

                    MenuSeparator{}

                    MenuItem {
                        text: "Добавить продукцию"
                        onClicked: storePopup.open()
                    }
                }
            }
        }
    }

    MainPage {
        id: mainPage
    }

    ProviderPage {
        id: providerPage
    }
    StorePage {
        id: storePage
    }

    footer: TabBar {
        id: tabBar
        width: parent.width

        TabButton {
            id: mainTabButton
            text: qsTr("Главная")
            onToggled: stack.replace(mainPage)
            width: window.width * mainWindowObject.oneThirdPart
            height: implicitHeight
        }

        TabButton {
            id: providerTabButton
            text: qsTr("Поставщик")
            onToggled: stack.replace(providerPage)
            width: window.width * mainWindowObject.oneThirdPart
            height: implicitHeight
        }

        TabButton {
            id: productTabButton
            text: qsTr("Продукция")
            onToggled: stack.replace(storePage)
            width: window.width * mainWindowObject.oneThirdPart
            height: implicitHeight
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainPage

        replaceEnter: Transition {
            OpacityAnimator {
                from: 0
                to: 1
                duration: 400
                easing.type: Easing.OutCubic

            }
        }

        replaceExit: Transition {
            OpacityAnimator {
                from: 0
                to: 1
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }

    ProviderPopup {
        id: providerPopup
        x: parent.width * mainWindowObject.oneSecondPart - width * mainWindowObject.oneSecondPart
        y: parent.height * mainWindowObject.oneSecondPart  - height * mainWindowObject.oneSecondPart
    }

    CategoryPopup {
        id: categoryPopup
        x: parent.width * mainWindowObject.oneSecondPart - width * mainWindowObject.oneSecondPart
        y: parent.height * mainWindowObject.oneSecondPart  - height * mainWindowObject.oneSecondPart
    }

    StorePopup {
        id: storePopup
        x: parent.width * mainWindowObject.oneSecondPart - width * mainWindowObject.oneSecondPart
        y: parent.height * mainWindowObject.oneSecondPart  - height * mainWindowObject.oneSecondPart
    }
}
