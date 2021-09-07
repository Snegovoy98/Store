#include <QSortFilterProxyModel>


class PurchaseFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit PurchaseFilterProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setProductData(const QString &productValue);
    Q_INVOKABLE void setProviderData(const QString &providerValue);


protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;
};


