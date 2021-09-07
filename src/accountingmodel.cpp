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
    setEditStrategy(QSqlTableModel::OnRowChange);
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
                                        const double &writeOff, const double &finalBalance)
{
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
                                              const double &balanceBeginnig)
{
    query.prepare("SELECT balance_beginning FROM Accounting WHERE provider = :provider_value AND product_category = :category_value "
                  "AND product = :product_value AND product_unit :product_unit_value AND balance_beginning = :balance_beginning_value");
    query.bindValue(":provider_value", provider);
    query.bindValue(":caegory_value", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);
    query.bindValue(":balance_beginning_value", balanceBeginnig);

    if(!query.exec()) {
        qWarning() << "Cannot get balance beginning value: " << lastError().text();
        return false;
    }

    if(query.first())
        return true;
    else
        return false;
}


void AccountingModel::updateAccountingData(const QString &provider, const QString &category,
                                           const QString &product, const QString &productUnit,
                                           const QSet<double> &newBalanceBeignningValues, const QSet<double> &newReportDataValues,
                                           const QSet<double> &newWriteOffValues, const QSet<double> &finalBalanceValues,
                                           const QSet<double> &oldBalanceBeginningValues, const QSet<double> &oldReportDataValues,
                                           const QSet<double> &oldWriteOffValues)
{
    query.prepare("UPDATE Accounting SET balance_beginning = :new_balance_beginning_value, "
                  "report_data = :new_report_data_value, final_balance = :new_final_balance "
                  "write_off = :new_write_off_data_value WHERE provider = :provider_value AND product_category = :category_value AND "
                  "product = :product_value AND product_unit = :prodcut_unit_value AND balance_beginning = :old_balance_beginning_value AND "
                  "report_data = :old_report_data_value AND write_off = :old_write_off_data_value");


       query.bindValue(":provider_value", provider);
       query.bindValue(":category_value", category);
       query.bindValue(":product_value", product);
       query.bindValue(":product_unit_value", productUnit);

       for(auto &newBalanceBeginning : newBalanceBeignningValues) {
           query.bindValue(":new_balance_beginning_value", newBalanceBeginning);

       }

       for(auto &newReportData : newReportDataValues) {
           query.bindValue(":new_report_data_value", newReportData);
       }

       for(auto &newWriteOff : newWriteOffValues) {
           query.bindValue(":new_write_off_data_value", newWriteOff);
       }

       for(auto &newFinalBalance : finalBalanceValues) {
           query.bindValue(":new_final_balance", newFinalBalance);
       }

       for(auto &oldBalanceBeginning : oldBalanceBeginningValues) {
           query.bindValue(":old_balance_beginning_value", oldBalanceBeginning);
       }

       for(auto &oldReportData : oldReportDataValues) {
           query.bindValue(":old_report_data_value", oldReportData);
       }

       for(auto &oldWriteOffData : oldWriteOffValues) {
           query.bindValue(":old_write_off_data_value", oldWriteOffData);
       }

        if(!query.exec()) {
            qWarning() << "Cannot update accounting data: " << lastError().text();
            return;
        }

        submit();
}


void AccountingModel::recalculatingAccountingData(const QString &provider, const QString &category,
                                                  const QString &product, const QString &productUnit,
                                                  const double &balanceBeginning, const double &reportData,
                                                  const double &writeOff)
{
    double balanceBeginningValue  {balanceBeginning};
    double reportDataValue        {reportData};
    double writeOffValue          {writeOff};
    double finalBalance           {balanceBeginningValue + reportDataValue - writeOffValue};
    double oldBalanceBeginning    {};
    double oldReportData          {};
    double oldWriteOff            {};
    double temp                   {};
    QSet<double> balanceBeginningValues;
    QSet<double> reportDataValues;
    QSet<double> writeOffValues;
    QSet<double> finalBalanceValues;
    QSet<double> oldBalanceBeginningValues;
    QSet<double> oldReportDataValues;
    QSet<double> oldWriteOffValues;

    query.prepare("SELECT balance_beginning, report_data, write_off FROM Accounting "
                  "WHERE provider = :provider_value AND product_category = :category AND product = :product_value AND "
                  "product_unit = :product_unit_value");

    query.bindValue(":provider_value", provider);
    query.bindValue(":ctaegory", category);
    query.bindValue(":product_value", product);
    query.bindValue(":product_unit_value", productUnit);

    QSqlRecord accountingRecord = query.record();

    int balanceBeginningIndex = accountingRecord.indexOf("balance_beginning");
    int reportDataIndex       = accountingRecord.indexOf("report_data");
    int writeOffIndex         = accountingRecord.indexOf("write_off");

    while(query.next()) {
        if(query.first()) {
            balanceBeginningValues.insert(balanceBeginningValue);
            reportDataValues.insert(reportDataValue);
            writeOffValues.insert(writeOffValue);
            finalBalanceValues.insert(finalBalance);
            temp = finalBalance;
            oldBalanceBeginning = query.value(balanceBeginningIndex).toDouble();
            oldReportData       = query.value(reportDataIndex).toDouble();
            oldWriteOff         = query.value(writeOffIndex).toDouble();
            oldBalanceBeginningValues.insert(oldBalanceBeginning);
            oldReportDataValues.insert(oldReportData);
            oldWriteOffValues.insert(oldWriteOff);
        } else {
            oldBalanceBeginning = query.value(balanceBeginningIndex).toDouble();
            oldReportData       = query.value(reportDataIndex).toDouble();
            oldWriteOff         = query.value(writeOffIndex).toDouble();
            balanceBeginningValue = temp;
            finalBalance = balanceBeginningValue + oldReportData - oldWriteOff;
            temp = finalBalance;
            balanceBeginningValues.insert(balanceBeginningValue);
            reportDataValues.insert(oldReportData);
            writeOffValues.insert(oldWriteOff);
            finalBalanceValues.insert(finalBalance);
            oldBalanceBeginningValues.insert(oldBalanceBeginning);
            oldReportDataValues.insert(oldReportData);
            oldWriteOffValues.insert(oldWriteOff);
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
