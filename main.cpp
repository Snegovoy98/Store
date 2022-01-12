#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtQml>
#include <QIcon>

#include <QStandardPaths>
#include <QSqlDatabase>
#include <QSqlError>


#include "include/accountingmodel.h"
#include "include/categoriesmodel.h"
#include "include/productsmodel.h"
#include "include/providersmodel.h"
#include "include/purchasemodel.h"
#include "include/purchasefilterproxymodel.h"
#include "include/reportsmodel.h"
#include "include/unitsmodel.h"





static void connectToDatabase()
{
    QSqlDatabase database = QSqlDatabase::database();
        if(!database.isValid()) {
            database = QSqlDatabase::addDatabase("QSQLITE");
            if(!database.isValid())
                qFatal("Cannot add database: %s", qPrintable(database.lastError().text()));
        }

       const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
       if(!writeDir.mkpath("."))
           qFatal("Failed create writable directory at %s", qPrintable(writeDir.absolutePath()));

       const QString fileName = writeDir.absolutePath() + "/store_db.sqlite3";
       database.setDatabaseName(fileName);

       if(!database.open()) {
           qFatal("Cannot open database: %s", qPrintable(database.lastError().text()));
           QFile::remove(fileName);
       }
}

static void registerTypes()
{
    qmlRegisterType<ProvidersModel>("store_db", 1, 0, "ProvidersModel");
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QIcon icon(":/resources/logo/store.ico");
    app.setWindowIcon(icon);
    app.setOrganizationName("store");
    app.setOrganizationDomain("store");
    QQuickStyle::setStyle("Universal");

    registerTypes();
    connectToDatabase();

    QQmlApplicationEngine engine;

    std::unique_ptr<AccountingModel> accounting               = std::make_unique<AccountingModel>();
    std::unique_ptr<CategorisModel> categoris                 = std::make_unique<CategorisModel>();
    std::unique_ptr<ProvidersModel> providers                 = std::make_unique<ProvidersModel>();
    std::unique_ptr<ProductsModel> products                   = std::make_unique<ProductsModel>();
    std::unique_ptr<PurchaseModel> purchase                   = std::make_unique<PurchaseModel>();
    std::unique_ptr<PurchaseFilterProxyModel> purchaseFPM     = std::make_unique<PurchaseFilterProxyModel>();
    std::unique_ptr<ReportsModel>  reports                    = std::make_unique<ReportsModel>();
    std::unique_ptr<UnitsModel> units                         = std::make_unique<UnitsModel>();

    purchaseFPM->setSourceModel(products.get());

    engine.rootContext()->setContextProperty("accountingModel", accounting.get());
    engine.rootContext()->setContextProperty("categoriesModel", categoris.get());
    engine.rootContext()->setContextProperty("productsModel", products.get());
    engine.rootContext()->setContextProperty("providersModel", providers.get());
    engine.rootContext()->setContextProperty("purchaseModel", purchase.get());
    engine.rootContext()->setContextProperty("purchaseFilterModel", purchaseFPM.get());
    engine.rootContext()->setContextProperty("reportsModel", reports.get());
    engine.rootContext()->setContextProperty("unitsModel", units.get());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
