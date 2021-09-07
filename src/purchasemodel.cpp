#include "include/purchasemodel.h"

static const char * purchaseTableName = "Purchase";

static void createTable()
{
    QSqlQuery query;
    query.exec("PRAGMA foreign_keys = ON;");
    if(QSqlDatabase::database().tables().contains(purchaseTableName))
        return;

    if(!query.exec(
        "CREATE TABLE IF NOT EXISTS 'Purchase'("
        "'purchase_date' TEXT NOT NULL, "
        "'provider_name' TEXT NOT NULL, "
        "'product_name' TEXT NOT NULL, "
        "'price' DOUBLE NOT NULL, "
        "'weight' DOUBLE NOT NULL, "
        "'delivered_goods' DOUBLE NOT NULL, "
        "FOREIGN KEY ('provider_name') REFERENCES Providers ('provider_name'), "
        "FOREIGN KEY ('product_name') REFERENCES Products('product')"
     ")"))
        qFatal("Failed create purchase table: %s", qPrintable(query.lastError().text()));
}

PurchaseModel::PurchaseModel(QObject *parent)
    :QSqlTableModel(parent)
{
    createTable();
    setTable(purchaseTableName);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}


QVariant PurchaseModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord purchaseRecord = record(index.row());
    return purchaseRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> PurchaseModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole]     = "purchase_date";
    names[Qt::UserRole + 1] = "provider";
    names[Qt::UserRole + 2] = "product";
    names[Qt::UserRole + 3] = "price";
    names[Qt::UserRole + 4] = "weight";
    names[Qt::UserRole + 5] = "delivered_goods";

    return names;
}

void PurchaseModel::addPurchaseData(const QString &purchaseDate, const QString &providerName,
                                    const QString &productName, const double &price,
                                    const double &weight)
{
    const double deliveredGoods {price * weight};

    QSqlRecord purchaseRecord = record();
    purchaseRecord.setValue("purchase_date", purchaseDate);
    purchaseRecord.setValue("provider_name", providerName);
    purchaseRecord.setValue("product_name", productName);
    purchaseRecord.setValue("price", price);
    purchaseRecord.setValue("weight", weight);
    purchaseRecord.setValue("delivered_goods", deliveredGoods);

    if(!insertRecord(rowCount(), purchaseRecord)) {
        qWarning() << "Cannot insert purchase data: " << lastError().text();
        return;
    }
    submitAll();
}

void PurchaseModel::removePurchaseData(const int &index)
{
    if(!removeRow(index)) {
        qWarning() << "Cannot remove purchase data: " << lastError().text();
        return;
    }
    submitAll();
}

QVariant PurchaseModel::getProvidersStatistic(const QString &firstDate, const QString &secondDate)
{
    query.prepare("SELECT provider_name, delivered_goods FROM Purchase WHERE purchase_date BETWEEN :first_date AND :second_date");
    query.bindValue(":first_date", firstDate);
    query.bindValue(":second_date", secondDate);

    if(!query.exec()) {
        qWarning() << "Cannot get proivders statistic: " << lastError().text();
        return false;
    }

    QSqlRecord purchaseRecord = query.record();

    int providerNameIndex = purchaseRecord.indexOf("provider_name");
    int deliveryGoodIndex = purchaseRecord.indexOf("delivered_goods");

    this->periodData.clear();

    while (query.next())
        this->periodData.insert(query.value(providerNameIndex).toString(), query.value(deliveryGoodIndex).toDouble());

    return QVariant::fromValue(calculateGoodsOfProvider(this->periodData));
}


Q_DECLARE_ASSOCIATIVE_CONTAINER_METATYPE(QMultiMap);

QMap<QString, double> PurchaseModel::calculateGoodsOfProvider(const QMultiMap<QString, double> &periodData)
{
    const QList<QString> &providersList = periodData.keys();
    QMap<QString, double> cGoodsOfProv;

    double sum{};
    int provInd{};

    for(auto start = periodData.cbegin(); start != periodData.cend() && provInd < providersList.count() ; ++start, ++provInd) {
        if(providersList.at(provInd) == start.key()) {
            for(int i = 0; i < periodData.values(start.key()).count(); ++i) {
                sum += periodData.values(start.key()).value(i);
            }

            cGoodsOfProv.insert(start.key(), sum);
            sum = 0;
        }
    }

    return cGoodsOfProv;
}

void PurchaseModel::update()
{
    submitAll();
}

void PurchaseModel::updateProviderData()
{
    submitAll();
}

void PurchaseModel::updateProductData()
{
    submitAll();
}

