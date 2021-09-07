#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include <QDebug>

class ReportsModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit ReportsModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addReportData(const QString &enteryDate,
                                   const QString &finalDate,
                                   QMap<QString, double> providerData);

    Q_INVOKABLE void removeReportData(const int &index);

    Q_INVOKABLE void updateProviderData();
};


