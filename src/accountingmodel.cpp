#include "include/accountingmodel.h"

static const char* accountingTableName = "Accounting";

static void createTable()
{
    QSqlQuery query;
    query.exec("PRAGMA foreign_keys = ON;");

    if(QSqlDatabase::database().tables().contains(accountingTableName))
        return;

    if(!query.exec(
                "CREATE TABLE IF NOT EXISTS 'Accounting'("
                "'provider' TEXT NOT NULL, "
                "'product_category' TEXT NOT NULL, "
                "'product' TEXT NOT NULL, "
                "'product_unit' TEXT NOT NULL, "
                "'balance_beginning' DOUBLE NOT NULL, "
                "'report_data' DOUBLE NOT NULL, "
                "'write_off' DOUBLE NOT NULL, "
                "'final_balance' DOUBLE NOT NULL, "
                "FOREIGN KEY ('provider') REFERENCES Providers ('provider_name') ON UPDATE CASCADE,"
                "FOREIGN KEY ('product_category') REFERENCES Categories ('product_category') ON UPDATE CASCADE, "
                "FOREIGN KEY ('product') REFERENCES Products('product') ON UPDATE CASCADE"
                ")"))
        qFatal("Failed create accounting table: %s", qPrintable(query.lastError().text()));

}


AccountingModel::AccountingModel(QObject *parent)
    :QSqlTableModel(parent)
{
    createTable();
    setTable(accountingTableName);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnFieldChange);
    select();
}

QVariant AccountingModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord accountingRecord = record(index.row());
    return accountingRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> AccountingModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole]     = "provider";
    names[Qt::UserRole + 1] = "product_category";
    names[Qt::UserRole + 2] = "product";
    names[Qt::UserRole + 3] = "product_unit";
    names[Qt::UserRole + 4] = "balance_beginning";
    names[Qt::UserRole + 5] = "report_data";
    names[Qt::UserRole + 6] = "write_off";
    names[Qt::UserRole + 7] = "final_balance";

    return names;
}


double AccountingModel::getBalanceBeginningValue(const QString &provider, const QString &category,
                                                 const QString &product, const QString &productUnit)
{
    query.prepare("SELECT final_balance FROM Accounting WHERE provider = :provider_value AND product_category = :category_value "
                  "AND product = :product_value AND product_unit = :product_unit_value");
    query.bindValue(":provider_value", provider);
    query.bindValue(":category_value", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);

    if(!query.exec()) {
        qWarning() << "Cannot get balance beginning value: " << lastError().text();
        return 0;
    }

    QSqlRecord  accountingRecord = query.record();

    int balanceBeinningIndex = accountingRecord.indexOf("final_balance");

    while(query.next()) {
        if(query.last())
            return query.value(balanceBeinningIndex).toDouble();
        else
            continue;
    }

    return 0;
}


void AccountingModel::addAccountingData(const QString &provider, const QString &category,
                                        const QString &product, const QString &productUnit,
                                        const double &balanceBeginning, const double &reportData,
                                        const double &writeOff)
{
    const double &finalBalance {balanceBeginning + reportData - writeOff};
    QSqlRecord accountingRecord = record();

    accountingRecord.setValue("provider", provider);
    accountingRecord.setValue("product_category", category);
    accountingRecord.setValue("product", product);
    accountingRecord.setValue("product_unit", productUnit);
    accountingRecord.setValue("balance_beginning", balanceBeginning);
    accountingRecord.setValue("report_data", reportData);
    accountingRecord.setValue("write_off", writeOff);
    accountingRecord.setValue("final_balance", finalBalance);

    if(!insertRecord(rowCount(), accountingRecord)) {
        qWarning() << "Cannot add accounting data: " << lastError().text();
        return;
    }

    submitAll();
}


bool AccountingModel::isFirstBalanceBeginning(const QString &provider, const QString &category,
                                              const QString &product, const QString productUnit,
                                              const double &balanceBeginningValue)
{
    query.prepare("SELECT balance_beginning FROM Accounting WHERE provider = :provider_value AND product_category = :category_value "
                  "AND product = :product_value AND product_unit = :product_unit_value");
    query.bindValue(":provider_value", provider);
    query.bindValue(":category_value", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);

    if(!query.exec()) {
        qWarning() << "Cannot get balance beginning value: " << lastError().text();
        return false;
    }

    QSqlRecord  accountingRecord = query.record();

    int balanceBeginningIndex = accountingRecord.indexOf("balance_beginning");

    while(query.first()) {
        if(balanceBeginningValue == query.value(balanceBeginningIndex))
            return true;
        else
            return false;
    }

    return false;
}


void AccountingModel::updateAccountingData(const QString &provider, const QString &category,
                                           const QString &product, const QString &productUnit,
                                           const QList<double> &newBalanceBeginningValues, const QList<double> &newReportDataValues,
                                           const QList<double> &newWriteOffValues, const QList<double> &finalBalanceValues,
                                           const QList<double> &oldBalanceBeginningValues, const QList<double> &oldReportDataValues,
                                           const QList<double> &oldWriteOffValues)
{
    query.prepare("UPDATE Accounting SET balance_beginning = :new_balance_beginning_value, "
                  "report_data = :new_report_data_value, write_off = :new_write_off_data_value, "
                  "final_balance = :new_final_balance WHERE provider = :provider_value AND product_category = :category_value AND "
                  "product = :product_value AND product_unit = :product_unit_value AND balance_beginning = :old_balance_beginning_value AND "
                  "report_data = :old_report_data_value AND write_off = :old_write_off_data_value");



    for(int index = 0; index < newBalanceBeginningValues.size(); ++index) {
        query.bindValue(":provider_value", provider);
        query.bindValue(":category_value", category);
        query.bindValue(":product_value", product);
        query.bindValue(":product_unit_value", productUnit);
        query.bindValue(":new_balance_beginning_value", newBalanceBeginningValues.at(index));
        query.bindValue(":new_report_data_value", newReportDataValues.at(index));
        query.bindValue(":new_write_off_data_value", newWriteOffValues.at(index));
        query.bindValue(":new_final_balance", finalBalanceValues.at(index));
        query.bindValue(":old_balance_beginning_value", oldBalanceBeginningValues.at(index));
        query.bindValue(":old_report_data_value", oldReportDataValues.at(index));
        query.bindValue(":old_write_off_data_value", oldWriteOffValues.at(index));

        if(!query.exec()) {
            qWarning() << "Cannot update accounting data: " << lastError().text();
            return;
        }

        submit();
    }
    select();
}


void AccountingModel::recalculatingAccountingData(const QString &provider, const QString &category,
                                                  const QString &product, const QString &productUnit,
                                                  const double &balanceBeginning, const double &reportData,
                                                  const double &writeOff, const double &oldBalanceBeginningValue)
{
    double balanceBeginningValue  {balanceBeginning};
    double reportDataValue        {reportData};
    double writeOffValue          {writeOff};
    double finalBalance           {balanceBeginningValue + reportDataValue - writeOffValue};
    double oldBalanceBeginning    {oldBalanceBeginningValue};
    double oldReportData          {};
    double oldWriteOff            {};
    double temp                   {finalBalance};
    bool isNextEditElem          {false};
    QList<double> balanceBeginningValues;
    QList<double> reportDataValues;
    QList<double> writeOffValues;
    QList<double> finalBalanceValues;
    QList<double> oldBalanceBeginningValues;
    QList<double> oldReportDataValues;
    QList<double> oldWriteOffValues;

    query.prepare("SELECT balance_beginning, report_data, write_off FROM Accounting "
                  "WHERE provider = :provider_value AND product_category = :category AND product = :product_value AND "
                  "product_unit = :product_unit_value");

    query.bindValue(":provider_value", provider);
    query.bindValue(":category", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);

    query.exec();

    QSqlRecord accountingRecord = query.record();

    int balanceBeginningIndex = accountingRecord.indexOf("balance_beginning");
    int reportDataIndex       = accountingRecord.indexOf("report_data");
    int writeOffIndex         = accountingRecord.indexOf("write_off");

    while (query.next()) {
        if(oldBalanceBeginning == query.value(balanceBeginningIndex).toDouble()) {
            balanceBeginningValues.push_back(balanceBeginningValue);
            reportDataValues.push_back(reportDataValue);
            writeOffValues.push_back(writeOffValue);
            finalBalanceValues.push_back(finalBalance);
            oldBalanceBeginningValues.push_back(oldBalanceBeginningValue);
            oldReportData = query.value(reportDataIndex).toDouble();
            oldWriteOff   = query.value(writeOffIndex).toDouble();
            oldReportDataValues.push_back(oldReportData);
            oldWriteOffValues.push_back(oldWriteOff);
            isNextEditElem = true;
        } else if(isNextEditElem) {
            balanceBeginningValue = temp;
            reportDataValue = query.value(reportDataIndex).toDouble();
            writeOffValue   = query.value(writeOffIndex).toDouble();
            finalBalance = balanceBeginningValue + reportDataValue - writeOffValue;
            temp = finalBalance;
            oldBalanceBeginning = query.value(balanceBeginningIndex).toDouble();
            oldReportData       = reportDataValue;
            oldWriteOff         = writeOffValue;
            balanceBeginningValues.push_back(balanceBeginningValue);
            reportDataValues.push_back(reportDataValue);
            writeOffValues.push_back(writeOffValue);
            finalBalanceValues.push_back(finalBalance);
            oldBalanceBeginningValues.push_back(oldBalanceBeginning);
            oldReportDataValues.push_back(oldReportData);
            oldWriteOffValues.push_back(oldWriteOff);
        } else {
            continue;
        }
    }

    updateAccountingData(provider, category, product, productUnit,
                         balanceBeginningValues, reportDataValues,
                         writeOffValues, finalBalanceValues,
                         oldBalanceBeginningValues, oldReportDataValues,
                         oldWriteOffValues);
}

void AccountingModel::updateProviderData()
{
    submitAll();
}

void AccountingModel::updateCategoryData()
{
    submitAll();
}

void AccountingModel::updateProductData()
{
    submitAll();
}

void AccountingModel::updateUnitData()
{
    submitAll();
}
