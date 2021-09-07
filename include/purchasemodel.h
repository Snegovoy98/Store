#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include<QDebug>


class PurchaseModel : public QSqlTableModel
{
    Q_OBJECT

public:
    explicit  PurchaseModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addPurchaseData(const QString &purchaseDate,
                                     const QString &providerName,
                                     const QString &productName,
                                     const double &price,
                                     const double &weight);

    Q_INVOKABLE void removePurchaseData(const int &index);

    Q_INVOKABLE QVariant getProvidersStatistic(const QString &firstDate, const QString &secondDate);

    Q_INVOKABLE void update();

    Q_INVOKABLE void updateProviderData();

    Q_INVOKABLE void updateProductData();

private:
    QSqlQuery query;
    QMultiMap<QString, double> periodData;
    QMap<QString, double> calculateGoodsOfProvider(const QMultiMap<QString, double>& periodData);
};

