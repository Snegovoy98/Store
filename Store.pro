QT += quick quickcontrols2 sql core

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
   main.cpp \
   src/accountingmodel.cpp \
   src/purchasemodel.cpp \
   src/categoriesmodel.cpp \
   src/productsmodel.cpp \
   src/providersmodel.cpp \
   src/purchasefilterproxymodel.cpp \
   src/reportsmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    include/accountingmodel.h \
    include/categoriesmodel.h \
    include/productsmodel.h \
    include/providersmodel.h \
    include/purchasefilterproxymodel.h \
    include/purchasemodel.h \
    include/reportsmodel.h \


ICON = store.ico

RC_ICONS = store.ico

VERSION = 1.1.1
QMAKE_TARGET_COMPANY = Store LLC
QMAKE_TARGET_PRODUCT = Store
