#include "include/providersmodel.h"

static const char* providersTableName = "Providers";

static void createTable()
{
    if(QSqlDatabase::database().tables().contains(providersTableName))
        return;

    QSqlQuery query;

    if(!query.exec(
      "CREATE TABLE IF NOT EXISTS 'Providers'("
      "'provider_name' TEXT NOT NULL, "
      "'phone_number' TEXT NOT NULL, "
      "'email' TEXT NOT NULL, "
      "'provider_image_path' TEXT, "
      "PRIMARY KEY ('provider_name')"
                ")")){
        qFatal("Failed to query database: %s", qPrintable(query.lastError().text()));
    }
}


ProvidersModel::ProvidersModel(QObject * parent)
        : QSqlTableModel(parent)
{
    createTable();
    setTable(providersTableName);
    setSort(1, Qt::DescendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}


QString ProvidersModel::getProvider() const
{
    return provider_;
}


void ProvidersModel::setProvider(const QString &providerName)
{
    if(provider_ == providerName)
        return;

    provider_ = providerName;
    emit providerChanged();
    select();
}


QVariant ProvidersModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord sqlRecord = record(index.row());
    return sqlRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> ProvidersModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole]     = "provider";
    names[Qt::UserRole + 1] = "phone";
    names[Qt::UserRole + 2] = "email";
    names[Qt::UserRole + 3] = "provider_image_path";

    return names;
}


void ProvidersModel::addProviderData(const QString &providerName, const QString &phone,
                                     const QString &email)
{
    QSqlRecord providerRecord = record();

    providerRecord.setValue("provider_name", providerName);
    providerRecord.setValue("phone_number", phone);
    providerRecord.setValue("email", email);

    if(!insertRecord(rowCount(), providerRecord)) {
        qWarning() << "Failed to add provider: " << lastError().text();
        return;
    }

    submitAll();
}


void ProvidersModel::removeProvider(const int &index)
{
    if(!removeRow(index)) {
        qWarning() << "Failed to remove provider data: " << lastError().text();
    }

    submitAll();
    emit providerDeleted();
}


void ProvidersModel::setProviderLogo(const QString &providerName, const QString &imagePath)
{
    query.prepare("UPDATE Providers SET provider_image_path = :image_path WHERE provider_name =:provider");
    query.bindValue(":provider", providerName);
    query.bindValue(":image_path", imagePath);

    if(!query.exec()) {
        qWarning() << "Failed set provider image: " << lastError().text();
        return;
    }
    submitAll();
}

void ProvidersModel::editProviderData(const QString &oldProviderName, const QString &newProviderName,
                                      const QString &oldPhoneNumber, const QString &newPhoneNumber,
                                      const QString &oldEmailValue, const QString &newEmailValue)
{
    query.prepare("UPDATE Providers SET provider_name = :new_provider_name, phone_number = :new_phone_number, email = :new_email_value "
                  "WHERE provider_name = :old_provider_name AND phone_number = :old_phone_number AND email = :old_email_value");
    query.bindValue(":new_provider_name", newProviderName);
    query.bindValue(":new_phone_number", newPhoneNumber);
    query.bindValue(":new_email_value", newEmailValue);
    query.bindValue(":old_provider_name", oldProviderName);
    query.bindValue(":old_phone_number", oldPhoneNumber);
    query.bindValue(":old_email_value", oldEmailValue);

    if(!query.exec()) {
        qWarning() << "Failed update provider data: " << lastError().text();
        return;
    }
    submitAll();
    emit providerDataChanged();
}


bool ProvidersModel::isExistsProviderName(const QString &providerName)
{
    query.prepare("SELECT provider_name FROM Providers WHERE provider_name = :provider");
    query.bindValue(":provider", providerName);

    query.exec();

    if(query.first())
        return true;
    else
        return false;
}
