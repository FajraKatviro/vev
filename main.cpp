#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "peoplegroup.h"
#include "politicalgroup.h"
#include "somecountry.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SomeCountry>("vev",1,0,"SomeCountry");
    qmlRegisterType<PoliticalGroup>("vev",1,0,"PoliticalGroup");
    qmlRegisterType<PeopleGroup>("vev",1,0,"PeopleGroup");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
