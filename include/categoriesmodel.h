#include <QSqlTableModel>
#include <QSqlRelationalTableModel>
#include <QSqlQuery>

#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>

class CategorisModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QString category READ getCategory WRITE setCategory NOTIFY categoryChanged)
public:
    explicit CategorisModel(QObject * parent = nullptr);

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString getCategory() const;

    void setCategory(const QString &category);

    Q_SIGNAL void categoryChanged();

    Q_INVOKABLE void addCategory(const QString &category);
    Q_INVOKABLE void removeCategory(const int &index);
    Q_INVOKABLE void updateCategory(const QString &oldCategoryValue, const QString &newCategoryValue);
    Q_INVOKABLE void update();
    Q_INVOKABLE void updateCategorySignal();
    Q_INVOKABLE bool isExistsCategoryValue(const QString & categoryValue);


signals:
    void categoryDeleted();
    void categoryChangedValue();

private:
    QString category_;
    QSqlQuery query;
};


