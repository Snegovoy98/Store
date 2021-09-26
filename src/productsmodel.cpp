#include "include/productsmodel.h"


static const char* productsTableName = "Products";

static void createTable()
{
    QSqlQuery query;
    query.exec("PRAGMA foreign_keys = ON;");
    if(QSqlDatabase::database().tables().contains(productsTableName))
        return;
    if(!query.exec(
       "CREATE TABLE IF NOT EXISTS 'Products'("
       "'provider' TEXT NOT NULL, "
       "'category' TEXT NOT NULL, "
       "'product' TEXT NOT NULL, "
       "'price' DOUBLE NOT NULL, "
       "'product_unit' TEXT NOT NULL, "
       "PRIMARY KEY ('product'), "
       "FOREIGN KEY ('provider') REFERENCES Providers('provider_name') ON UPDATE CASCADE "
       "ON DELETE CASCADE, "
       "FOREIGN KEY ('category') REFERENCES Categories('product_category') ON UPDATE CASCADE"
    ")"))
        qFatal("Failed create table: %s", qPrintable(query.lastError().text()));
}

ProductsModel::ProductsModel(QObject *parent)
    :QSqlTableModel(parent)
{
    createTable();
    setTable(productsTableName);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}


QString ProductsModel::getProduct() const
{
    return product_;
}

void ProductsModel::setProduct(const QString &product)
{
    if(product_ == product)
        return;
    product_ = product;
    emit productChanged();
}

QVariant ProductsModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord productRecord = record(index.row());
    return productRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> ProductsModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole]     = "provider";
    names[Qt::UserRole + 1] = "category";
    names[Qt::UserRole + 2] = "product";
    names[Qt::UserRole + 3] = "price";
    names[Qt::UserRole + 4] = "product_unit";

    return names;
}


void ProductsModel::addProductData(const QString &provider, const QString &category,
                                   const QString &product, const double &price,
                                   const QString &productUnit)
{
    QSqlRecord productRecord = record();
    productRecord.setValue("provider", provider);
    productRecord.setValue("category", category);
    productRecord.setValue("product", product);
    productRecord.setValue("price", price);
    productRecord.setValue("product_unit", productUnit);

    if(!insertRecord(rowCount(), productRecord)) {
        qWarning() << "Cannot add product data to table: " << lastError().text();
        return;
    }

    submitAll();
}

void ProductsModel::removeProductData(const int &index)
{
    if(!removeRow(index)) {
        qWarning() << "Cannot remove product data: " << lastError().text();
        return;
    }
    submitAll();
    emit productDeleted();
}

void ProductsModel::updateProductData(const QString &provider, const QString &newProductValue, const double &newPriceValue,
                                      const QString &newProductUnitValue, const QString &oldProductValue,
                                      const double &oldPriceValue, const QString &oldProductUnitValue)
{
    query.prepare("UPDATE Products SET product = :new_product_value, price = :new_price_value, product_unit = :new_product_unit_value "
                  "WHERE provider = :provider_name AND product = :old_product_value AND price = :old_price_value "
                  "AND product_unit = :old_product_unit_value");
    query.bindValue(":provider_name", provider);
    query.bindValue(":new_product_value", newProductValue);
    query.bindValue(":new_price_value", newPriceValue);
    query.bindValue(":new_product_unit_value", newProductUnitValue);
    query.bindValue(":old_product_value", oldProductValue);
    query.bindValue(":old_price_value", oldPriceValue);
    query.bindValue(":old_product_unit_value", oldProductUnitValue);

    if(!query.exec()) {
        qWarning() << "Cannot update products table: " << lastError().text();
        return;
    }
    submitAll();
    emit productUpdated();
}

void ProductsModel::update()
{
    submitAll();
}

void ProductsModel::updateProductValue()
{
    submitAll();
}

bool ProductsModel::isEqualSelectedValues(const QString &provider, const QString &category,
                                            const QString &product, const QString productUnit)
{
    query.prepare("SELECT provider FROM Products WHERE provider = :provider_value AND"
                  " category = :category_value AND product = :product_value AND product_unit = :product_unit_value");
    query.bindValue(":provider_value", provider);
    query.bindValue(":category_value", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);

    if(!query.exec()) {
        qWarning() << "Cannot select data from table: " << lastError().text();
        return false;
    }

    if(query.first())
        return true;
    else
        return false;
}
