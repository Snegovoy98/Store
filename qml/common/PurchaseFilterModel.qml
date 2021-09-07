import QtQuick 2.12
import QtQml.Models 2.12

DelegateModel {
    id: delegateModel
    property var lessThan: function(left, right) {return true;}
    property var filterAcceptsItem: function(item) {return true;}
    property string provider: ""
    function ifCompare (item, provider) {if(item === provider){return true;} else {return false;}}

    groups: DelegateModelGroup {
        id: visibleItems

        name: "visible"
        includeByDefault: false
    }

    filterOnGroup: "visible"

    function update() {
        if (items.count > 0) {
            items.setGroups(0, items.count, "items");
        }
        var visible = [];
        for (var i = 0; i < items.count; ++i) {
            var item = items.get(i);
            if (filterAcceptsItem(item.model)) {
                if(ifCompare(item.model.provider, provider)) {
                    if(productTf.length > 0) {
                        visible.push(item);
                    } else {
                        visible.pop(item);
                    }
                }
            }
        }


        visible.sort(function(a, b) {
            return lessThan(a.model, b.model) ? -1 : 1;
        });

        for (i = 0; i < visible.length; ++i) {
            item = visible[i];
            item.inVisible = true;

            if(item.visibleIndex !== i) {
                visibleItems.move(item.visibleIndex, i, 1);
            }
        }
    }
}
