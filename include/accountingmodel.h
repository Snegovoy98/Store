#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include <QDebug>

class AccountingModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit AccountingModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE double getBalanceBeginningValue(const QString &provider, const QString &category,
                                                const QString &product, const QString &productUnit);

    Q_INVOKABLE void addAccountingData(const QString &provider, const QString &category,
                                       const QString &product, const QString &productUnit,
                                       const double &balanceBeginning, const double &reportData,
                                       const double &writeOff);

    Q_INVOKABLE bool isFirstBalanceBeginning(const QString &provider, const QString &category,
                                             const QString &product, const QString productUnit,
                                             const double &balanceBeginningValue);

     void updateAccountingData(const QString &provider, const QString &category,
                                          const QString &product, const QString &productUnit,
                                          const QList<double> &newBalanceBeginningValues, const QList<double> &newReportDataValues,
                                          const QList<double> &newWriteOffValues, const QList<double> &finalBalanceValues,
                                          const QList<double> &oldBalanceBeginningValues, const QList<double> &oldReportDataValues,
                                          const QList<double> &oldWriteOffValues);

     Q_INVOKABLE void recalculatingAccountingData(const QString &provider, const QString &category,
                                                  const QString &product, const QString &productUnit,
                                                  const double &balanceBeginning, const double &reportData,
                                                  const double &writeOff, const double &oldBalanceBeginningValue);

     Q_INVOKABLE void updateProviderData();
     Q_INVOKABLE void updateCategoryData();
     Q_INVOKABLE void updateProductData();
private:
     QSqlQuery query;     
};


