#include "include/unitsmodel.h"

static const char* unitTableNames = "Units";

static void createTable()
{
    QSqlQuery query;
    query.exec("PRAGMA foreign_key = ON;");

    if(QSqlDatabase::database().tables().contains(unitTableNames))
        return;
    if(!query.exec(
       "CREATE TABLE IF NOT EXISTS 'Units'("
       "'unit' TEXT NOT NULL, "
       "PRIMARY KEY ('unit')"
       ")"))
        qFatal("Failed create unit table: %s", qPrintable(query.lastError().text()));

}


UnitsModel::UnitsModel(QObject* parent):
    QSqlTableModel(parent)
{
    createTable();
    setTable(unitTableNames);
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QString UnitsModel::getUnit() const
{
    return unit_;
}

void UnitsModel::setUnit(const QString &unit)
{
    if(unit_ == unit)
        return;
    unit_ = unit;

    emit unitChanged();
    select();
}


QVariant UnitsModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    QSqlRecord unitRecord = record(index.row());
    return unitRecord.value(role - Qt::UserRole);
}


QHash<int, QByteArray> UnitsModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[Qt::UserRole] = "unit";

    return names;
}

void UnitsModel::addUnit(const QString &unit)
{
    QSqlRecord unitRecord = record();

    unitRecord.setValue("unit", unit);

    if(!insertRecord(rowCount(), unitRecord)) {
        qWarning() << "Cannot adding new unit value: " << lastError().text();
        return;
    }
    submitAll();
}

void UnitsModel::updateUnit(const QString &newUnitValue, const QString &oldUnitValue)
{
    query.prepare("UPDATE Units SET unit = :new_unit_value WHERE unit = :old_unit_value");

    query.bindValue(":new_unit_value", newUnitValue);
    query.bindValue(":old_unit_value", oldUnitValue);

    if(!query.exec())
        qWarning() << "Cannot update unit: %s" << lastError().text();

    submitAll();
    emit unitChangedValue();
}

void UnitsModel::removeUnit(const int &index)
{
    if(!removeRow(index))
        qWarning() << "Cannot delete unit data: %s" << lastError().text();

    submitAll();
    emit unitDeleted();
}

bool UnitsModel::isExists(const QString &unit)
{
    query.prepare("SELECT unit FROM Units WHERE unit = :unit_value");
    query.bindValue(":unit_value", unit);

    if(!query.exec()) {
        qWarning() << "Cannot select unit data: %s" << lastError().text();
        return true;
    }

    while(query.next()) {
        if(query.first())
           return true;
        else
          return false;
    }

    return false;
}
