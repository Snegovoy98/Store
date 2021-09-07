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
                                       const double &writeOff, const double &finalBalance);

    Q_INVOKABLE bool isFirstBalanceBeginning(const QString &provider, const QString &category,
                                             const QString &product, const QString productUnit,
                                             const double &balanceBeginnig);

     void updateAccountingData(const QString &provider, const QString &category,
                                          const QString &product, const QString &productUnit,
                                          const QSet<double> &newBalanceBeignningValues, const QSet<double> &newReportDataValues,
                                          const QSet<double> &newWriteOffValues, const QSet<double> &finalBalanceValues,
                                          const QSet<double> &oldBalanceBeginningValues, const QSet<double> &oldReportDataValues,
                                          const QSet<double> &oldWriteOffValues);

     Q_INVOKABLE void recalculatingAccountingData(const QString &provider, const QString &category,
                                                  const QString &product, const QString &productUnit,
                                                  const double &balanceBeginning, const double &reportData,
                                                  const double &writeOff);

     Q_INVOKABLE void updateProviderData();
     Q_INVOKABLE void updateCategoryData();
     Q_INVOKABLE void updateProductData();
private:
     QSqlQuery query;
};


