import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: categoryPopup

    width: 350
    height: 170

    modal: true
    focus: true

    property string old_category_value: ""
    property string new_category_value: ""

    signal okClicked();

    QtObject {
        id: categoryPopupObject

        property string fontFamily: "Decorative"
        property int fontPointSize: 12
        property string textColor: "black"
        property string errorColor: "red"
        property string errorMessage: "Поле не может быть пустым"
        property string isExistsErrorMessage: "Категория с таким названием уже существует"
        property string borderColor: "#5D76CB"
        property int borderWidth: 1
        property double oneSecondPart: 1/2
    }


    function editingCategoryData() {
        if(checkInputData()) {
            new_category_value = categoryEditingTF.text
            okClicked()
            categoryPopup.close()
        }
    }

    function checkInputData() {
        var errorCounter = 0
        if(categoryEditingTF.text.length === 0) {
            categoryEditingMessageLbl.text    = categoryPopupObject.errorMessage
            categoryEditingMessageLbl.visible = true
            ++errorCounter
        } else if(categoriesModel.isExistsCategoryValue(categoryEditingTF.text)) {
            categoryEditingMessageLbl.text = categoryPopupObject.isExistsErrorMessage
            categoryEditingMessageLbl.visible = true
            ++errorCounter
        } else {
            categoryEditingMessageLbl.visible = false
        }

        if(errorCounter === 0)
            return true
        else
            return false
    }

    onClosed: {
        categoryEditingMessageLbl.visible = false
        categoryEditingTF.text            = old_category_value
    }

    Rectangle {
        id: mainCategoryRect
        anchors.fill: parent
        border.width: categoryPopupObject.borderWidth
        border.color: categoryPopupObject.borderColor
        radius: 5

        ColumnLayout {
            width: parent.width
            height: parent.height

            TextField {
                id: categoryEditingTF
                text: old_category_value
                font.family: categoryPopupObject.fontFamily
                font.pointSize: categoryPopupObject.fontPointSize
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                selectByMouse: true
                horizontalAlignment: TextInput.AlignHCenter
                validator: RegExpValidator{regExp: /[А-Яа-я]+/}
            }

            Label {
                id: categoryEditingMessageLbl
                font.family: categoryPopupObject.fontFamily
                font.pointSize: categoryPopupObject.fontPointSize
                color: categoryPopupObject.errorColor
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            Button {
                id: editingBtn
                text: "Редактировать"
                font.family: categoryPopupObject.fontFamily
                font.pointSize: categoryPopupObject.fontPointSize
                highlighted: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                onClicked: editingCategoryData()
            }
        }
    }
}
