#ifndef POLITICALGROUP_H
#define POLITICALGROUP_H

#include <QObject>
#include <QQmlListProperty>
#include <QList>

#include "peoplegroup.h"

class PoliticalGroup : public QObject{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<PeopleGroup> peopleGroups READ peopleGroups NOTIFY peopleGroupsChanged)
    Q_PROPERTY(PoliticalGroup* enemyGroup READ enemyGroup WRITE setEnemyGroup NOTIFY enemyGroupChanged)
    Q_PROPERTY(PeopleGroup* fanatics READ fanatics WRITE setFanatics NOTIFY fanaticsChanged)

    Q_PROPERTY(double enemyTargetChance READ enemyTargetChance WRITE setEnemyTargetChance NOTIFY enemyTargetChanceChanged)
    Q_PROPERTY(double performFanaticActionChance READ performFanaticActionChance WRITE setPerformFanaticActionChance NOTIFY performFanaticActionChanceChanged)
public:
    explicit PoliticalGroup(QObject *parent = 0);

    int countFanaticActions()const;

    PoliticalGroup* enemyGroup()const;
    double enemyTargetChance()const;
    double performFanaticActionChance()const;

    PeopleGroup* fanatics()const;

    int countPeople()const;

    bool applyFanaticAction();

    void setEnemyGroup(PoliticalGroup* arg);
    void setFanatics(PeopleGroup* arg);

signals:
    void peopleGroupsChanged();
    void enemyGroupChanged();
    void fanaticsChanged();

    void enemyTargetChanceChanged();
    void performFanaticActionChanceChanged();

public slots:

private:
    QQmlListProperty<PeopleGroup> peopleGroups();

    QList<PeopleGroup*> _peopleGroups;
    static void addPeopleGroup(QQmlListProperty<PeopleGroup>* property, PeopleGroup* group);
    static PeopleGroup* getPeopleGroup(QQmlListProperty<PeopleGroup>* property, int index);
    static int countPeopleGroups(QQmlListProperty<PeopleGroup>* property);
    static void resetPeopleGroups(QQmlListProperty<PeopleGroup>* property);

    void setEnemyTargetChance(double arg);
    void setPerformFanaticActionChance(double arg);

    PoliticalGroup* _enemyGroup = nullptr;
    PeopleGroup* _fanatics = nullptr;

    double _enemyTargetChance = 0.9;
    double _performFanaticActionChance = 0.1;

};

#endif // POLITICALGROUP_H
