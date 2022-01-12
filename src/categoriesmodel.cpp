
#include "include/categoriesmodel.h"


static const char* categoriesTableName = "Categories";

static void createTable() {
    QSqlQuery query;

     query.exec("PRAGMA foreign_key ON;");

    if(QSqlDatabase::database().tables().contains(categoriesTableName))
        return;

    if(!query.exec(
        "CREATE TABLE IF NOT EXISTS 'Categories'("
        "'product_category' TEXT NOT NULL, "
        "PRIMARY KEY ('product_category')"
        ")")) {
            qFatal("Failed create categories table: %s", qPrintable(query.lastError().text()));
    }
}

CategorisModel::CategorisModel(QObject *parent)
    : QSqlTableModel(parent)
{
    createTable();
    setTable(categoriesTableName);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QString CategorisModel::getCategory() const
{
    return category_;
}

void CategorisModel::setCategory(const QString &category)
{
    if(category_ == category)
        return;
    category_ = category;
    emit categoryChanged();
    select();
}


QVariant CategorisModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord categoryRecord = record(index.row());
    return categoryRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> CategorisModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole] = "product_category";

    return names;
}


void CategorisModel::addCategory(const QString &category)
{
    QSqlRecord categoryRecord = record();
    categoryRecord.setValue("product_category", category);

    if(!insertRecord(rowCount(), categoryRecord)) {
        qWarning() << "Cannot add category data to table: " << lastError().text();
        return;
    }
    submitAll();
}

void CategorisModel::removeCategory(const int &index)
{
    if(!removeRow(index)) {
        qWarning() << "Cannot remove category data: " << lastError().text();
        return;
    }
    submitAll();
    emit categoryDeleted();
}


void CategorisModel::updateCategory(const QString &oldCategoryValue, const QString &newCategoryValue)
{
    query.prepare("UPDATE Categories SET product_category = :new_product_category WHERE product_category = :old_product_category");
    query.bindValue(":new_product_category", newCategoryValue);
    query.bindValue(":old_product_category", oldCategoryValue);

    if(!query.exec()) {
        qWarning() << "Cannot update category table: " << lastError().text();
        return;
    }

    submitAll();
    emit categoryChangedValue();
}

void CategorisModel::update()
{
    submitAll();
}

void CategorisModel::updateCategorySignal()
{
    submitAll();
}

bool CategorisModel::isExistsCategoryValue(const QString &categoryValue)
{
    query.prepare("SELECT product_category FROM Categories WHERE product_category = :category_value");
    query.bindValue(":category_value", categoryValue);
    query.exec();

    if(query.first())
        return true;
    else
        return false;
}
