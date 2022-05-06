#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QTranslator>
#include <QLocale>
#include <QString>
#include "qdiriterator.h"
#include "qfontdatabase.h"
#include "sidebar_state.hpp"
#include "test_request.hpp"


int main(int argc, char *argv[])
{    
    // App
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("Etovex");
    QGuiApplication::setOrganizationDomain("Etovex.com");
    QGuiApplication::setApplicationName("Librum");
    
    
    TestRequest tr;
    
    // Translations
    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "Librum_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            QGuiApplication::installTranslator(&translator);
            break;
        }
    }



    // Loading fonts
    const QString fontsPath = QGuiApplication::instance()->applicationDirPath() + "/resources/fonts/";
    const QDir fontsDir(fontsPath);
    if(!fontsDir.isEmpty() && fontsDir.exists())
    {
        QDirIterator it(fontsPath);
        while(it.hasNext())
        {
            QFontDatabase::addApplicationFont(it.next());
        }
    }
    else
    {
        qWarning() << "Unable to load application fonts from " + fontsPath;
    }



    // Type registering
    SidebarState sidebarState;
    qmlRegisterSingletonInstance("librum.extensions.sidebar", 1, 0, "SidebarState", &sidebarState);

    
    
    // Startup
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/sources/src/app/view/modules");
    
    const QUrl url(u"qrc:/sources/src/app/view/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}