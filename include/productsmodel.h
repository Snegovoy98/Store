#include <QSqlTableModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>

#include <QDebug>

class ProductsModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QString product READ getProduct WRITE setProduct NOTIFY productChanged)
public:
    explicit ProductsModel(QObject * parent = nullptr);

    QString getProduct() const;

    void setProduct(const QString &product);

    Q_SIGNAL void productChanged();

    QVariant data(const QModelIndex &index, int role) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addProductData(const QString &provider, const QString &category,
                        const QString &product, const double &price,
                        const QString &productUnit);

    Q_INVOKABLE void removeProductData(const int &index);

    Q_INVOKABLE void updateProductData(const QString &provider, const QString &newProductValue, const double &newPriceValue,
                                       const QString &newProductUnitValue, const QString &oldProductValue,
                                       const double &oldPriceValue, const QString &oldProductUnitValue);
    Q_INVOKABLE void update();

    Q_INVOKABLE void updateProductValue();

    Q_INVOKABLE bool isEqualSelectedValues(const QString &provider, const QString &category,
                                           const QString &product, const QString productUnit);

signals:
    void productDeleted();
    void productUpdated();

private:
    QString product_;
    QSqlQuery query;
};


