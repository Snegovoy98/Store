#include "include/accountingfilterproxymodel.h"

AccountingFilterProxyModel::AccountingFilterProxyModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
}

bool AccountingFilterProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QVariant leftData  = sourceModel()->data(left);
    QVariant rightData = sourceModel()->data(right);

    if(leftData.userType() == QMetaType::QString)
        return leftData.toString() < rightData.toString();

    return false;
}


bool AccountingFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index  = sourceModel()->index(sourceRow, 0, sourceParent);
    QModelIndex index1 = sourceModel()->index(sourceRow, 1, sourceParent);
    QModelIndex index2 = sourceModel()->index(sourceRow, 2, sourceParent);
    QModelIndex index3 = sourceModel()->index(sourceRow, 3, sourceParent);

    if(sourceModel()->data(index).toString().contains(filterRegExp()) ||
       sourceModel()->data(index1).toString().contains(filterRegExp()) ||
       sourceModel()->data(index2).toString().contains(filterRegExp())||
       sourceModel()->data(index3).toString().contains(filterRegExp()))
        return true;

    return false;
}


void AccountingFilterProxyModel::setProviderData(const QString &provider)
{
    QRegExp regExp(provider, Qt::CaseSensitive, QRegExp::FixedString);

    setFilterRegExp(regExp);

    invalidateFilter();
}


void AccountingFilterProxyModel::setCategoryData(const QString &category)
{
    QRegExp regExp(category, Qt::CaseSensitive, QRegExp::FixedString);

    setFilterRegExp(regExp);

    invalidateFilter();
}


void AccountingFilterProxyModel::setProductData(const QString &product)
{
    QRegExp regExp(product, Qt::CaseSensitive, QRegExp::FixedString);

    setFilterRegExp(regExp);

    invalidateFilter();
}

void AccountingFilterProxyModel::setProductUnitData(const QString &productUnit)
{
    QRegExp regExp(productUnit, Qt::CaseSensitive, QRegExp::FixedString);

    setFilterRegExp(regExp);

   invalidateFilter();
}
