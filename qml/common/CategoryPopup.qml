import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: categoryRoot
    width: 350
    height: 250

    modal: true
    focus: true

    QtObject {
        id: categoryObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string isExistsErrorMessage: "Категория с таким названием уже существует"
        property double oneSecondPart: 1/2
    }

    onClosed: categoryMessageLbl.visible = false

    function addingCategoryData() {
        if(checkInputData()){
            categoriesModel.addCategory(categoryTF.text)
            categoryTF.clear()
            categoryRoot.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0

        if(categoryTF.text.length === 0) {
            categoryMessageLbl.text    = categoryObject.errorMessage
            categoryMessageLbl.visible = true
            ++errorCounter
        } else if(categoriesModel.isExistsCategoryValue(categoryTF.text)){
            categoryMessageLbl.text    = categoryObject.isExistsErrorMessage
            categoryMessageLbl.visible = true
            ++errorCounter
        } else {
            categoryMessageLbl.visible = false
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent

        Label {
            text: "Введите данные о котегории"
            font.family: categoryObject.fontFamily
            font.pointSize: categoryObject.fontPointSize
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: categoryObject.textColor
        }

        MenuSeparator {Layout.fillWidth: true}

        TextField {
            id: categoryTF
            placeholderText: "Введите название категории"
            font.family: categoryObject.fontFamily
            font.pointSize: categoryObject.fontPointSize
            selectByMouse: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: TextInput.AlignHCenter
        }

        Label {
            id: categoryMessageLbl
            text: categoryObject.errorMessage
            font.family: categoryObject.fontFamily
            font.pointSize: categoryObject.fontPointSize
            color: categoryObject.errorColor
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: false
        }

        Button {
            id: addBtn
            text: "Добавить"
            font.family: categoryObject.fontFamily
            font.pointSize: categoryObject.fontPointSize
            highlighted: true
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            onClicked: addingCategoryData()
        }
    }
}
