#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "commonPaths.h"

#include "peoplegroup.h"
#include "politicalgroup.h"
#include "somecountry.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SomeCountry>("modules.vev",1,0,"SomeCountry");
    qmlRegisterType<PoliticalGroup>("modules.vev",1,0,"PoliticalGroup");
    qmlRegisterType<PeopleGroup>("modules.vev",1,0,"PeopleGroup");

    engine.addImportPath("qrc:/");
#if (QT_VERSION == QT_VERSION_CHECK(5, 9, 2)) && defined(Q_OS_MACOS)
    engine.rootContext()->setContextProperty("resourceDir",app.applicationDirPath() + "/../Resources/constAppData");
#else
    engine.rootContext()->setContextProperty("resourceDir",FKUtility::dataDir().absolutePath());
#endif
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
