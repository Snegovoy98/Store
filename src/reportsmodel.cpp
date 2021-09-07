#include "include/reportsmodel.h"

static const char* reportsTableName = "Reports";

static void createTable()
{
    QSqlQuery query;
    query.exec("PRAGMA foreign_keys = ON;");

    if(QSqlDatabase::database().tables().contains(reportsTableName))
        return;

    if(!query.exec(
     "CREATE TABLE IF NOT EXISTS 'Reports'("
     "'entery_date' TEXT NOT NULL, "
     "'final_date' TEXT NOT NULL, "
     "'provider' TEXT NOT NULL, "
     "'purchase_sum' DOUBLE NOT NULL, "
     "FOREIGN KEY ('provider') REFERENCES Providers('provider_name') ON UPDATE CASCADE"
    ")"))
        qFatal("Failed create reports table: %s", qPrintable(query.lastError().text()));
}

ReportsModel::ReportsModel(QObject *parent)
    :QSqlTableModel(parent)
{
    createTable();
    setTable(reportsTableName);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QVariant ReportsModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord reportsRecord = record(index.row());
    return reportsRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> ReportsModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole]     = "entery_date";
    names[Qt::UserRole + 1] = "final_date";
    names[Qt::UserRole + 2] = "provider";
    names[Qt::UserRole + 3] = "purchase_sum";

    return names;
}

void ReportsModel::addReportData(const QString &enteryDate, const QString &finalDate, QMap<QString, double> providerData)
{
    QSqlRecord reportsRecord = record();

    for(auto start = providerData.cbegin(); start != providerData.cend(); ++start) {
        reportsRecord.setValue("entery_date", enteryDate);
        reportsRecord.setValue("final_date", finalDate);
        reportsRecord.setValue("provider", start.key());
        reportsRecord.setValue("purchase_sum", start.value());
    }

    if(!insertRecord(rowCount(), reportsRecord)) {
        qWarning() << "Cannot add reports data to table: " << lastError().text();
        return;
    }
    submit();
}

void ReportsModel::removeReportData(const int &index)
{
    if(!removeRow(index)) {
        qWarning() << "Cannot remove report data: " << lastError().text();
        return;
    }
    submitAll();
}

void ReportsModel::updateProviderData()
{
    submitAll();
}
