#include <QGuiApplication>
#include <QQmlApplicationEngine>

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
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
