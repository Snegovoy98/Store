#include <QSqlTableModel>
#include <QSqlQuery>

#include <QDebug>
#include<QSqlError>
#include <QSqlRecord>


class ProvidersModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QString provider READ getProvider WRITE setProvider NOTIFY providerChanged);
public:
    explicit ProvidersModel(QObject * parent = nullptr);

    QString getProvider() const;
    void setProvider(const QString &providerName);
    Q_SIGNAL void providerChanged();

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addProviderData(const QString &providerName, const QString &phone,
                                     const QString &email);
    Q_INVOKABLE void removeProvider(const int &index);
    Q_INVOKABLE void setProviderLogo(const QString &providerName, const QString &imagePath);
    Q_INVOKABLE void editProviderData(const QString &oldProviderName, const QString &newProviderName,
                                      const QString &oldPhoneNumber, const QString &newPhoneNumber,
                                      const QString &oldEmailValue, const QString &newEmailValue);
    Q_INVOKABLE bool isExistsProviderName(const QString &providerName);

signals:
    void providerDeleted();
    void providerDataChanged();

private:
    QString provider_;
    QSqlQuery query;
};


