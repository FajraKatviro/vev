#ifndef SOMECOUNTRY_H
#define SOMECOUNTRY_H

#include <QObject>
#include <QQmlListProperty>

#include "politicalgroup.h"

class SomeCountry : public QObject{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<PoliticalGroup> groups READ groups NOTIFY groupsChanged)
public:
    explicit SomeCountry(QObject *parent = 0);

    int population()const;

signals:
    void groupsChanged();
    void extinction();

public slots:
    void performFanaticActions();


private:
    void performFanaticAction(PoliticalGroup* source);

    QQmlListProperty<PoliticalGroup> groups();

    QList<PoliticalGroup*> _groups;
    static void addGroup(QQmlListProperty<PoliticalGroup>* property, PoliticalGroup* group);
    static PoliticalGroup* getGroup(QQmlListProperty<PoliticalGroup>* property, int index);
    static int countGroups(QQmlListProperty<PoliticalGroup>* property);
    static void resetGroups(QQmlListProperty<PoliticalGroup>* property);

};

#endif // SOMECOUNTRY_H
