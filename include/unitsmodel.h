#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include <QDebug>

class UnitsModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QString unit READ getUnit WRITE setUnit NOTIFY unitChanged);
public:
    explicit UnitsModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString getUnit() const;

    void setUnit(const QString& unit);

    Q_SIGNAL void unitChanged();

  Q_INVOKABLE  void addUnit(const QString& unit);

  Q_INVOKABLE  void updateUnit(const QString& newUnitValue, const QString& oldUnitValue);

  Q_INVOKABLE  void removeUnit(const int& index);

  Q_INVOKABLE  bool isExists(const QString& unit);

signals:
    void unitChangedValue();
    void unitDeleted();

private:
    QString unit_;
    QSqlQuery query;
};


