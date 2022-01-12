#include "include/purchasefilterproxymodel.h"
#include <QDebug>

PurchaseFilterProxyModel::PurchaseFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}

bool PurchaseFilterProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QVariant leftData  = sourceModel()->data(left);
    QVariant rightData = sourceModel()->data(right);

    if(leftData.userType() == QMetaType::QString) {
        return leftData.toString() < rightData.toString();
    }
    return false;
}

bool PurchaseFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index  = sourceModel()->index(sourceRow, 1, sourceParent);
    QModelIndex index1 = sourceModel()->index(sourceRow, 2, sourceParent);

    if(sourceModel()->data(index).toString().contains(filterRegExp()) ||
            sourceModel()->data(index1).toString().contains(filterRegExp()))
             return true;
    return false;
}


void PurchaseFilterProxyModel::setProductData(const QString &productValue)
{
    QRegExp regExp(productValue, Qt::CaseSensitive, QRegExp::FixedString);

   setFilterRegExp(regExp);

   invalidateFilter();
}

void PurchaseFilterProxyModel::setProviderData(const QString &providerValue)
{
    QRegExp regExp(providerValue, Qt::CaseSensitive, QRegExp::FixedString);

    setFilterRegExp(regExp);

    invalidateFilter();
}
