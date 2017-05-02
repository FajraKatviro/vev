#include "somecountry.h"

#include <QTime>

SomeCountry::SomeCountry(QObject *parent) : QObject(parent)
{
    qsrand(QTime::currentTime().msec());
}

int SomeCountry::population() const{
    int p = 0;
    for(auto g:_groups){
        p += g->countPeople();
    }
    return p;
}

void SomeCountry::performFanaticActions(){
    for(auto g:_groups){
        int actions = g->countFanaticActions();
        while(actions--){
            performFanaticAction(g);
        }
    }
}

void SomeCountry::performFanaticAction(PoliticalGroup* source){
    PoliticalGroup* enemyBlock = source->enemyGroup();
    int enemyPopulation = enemyBlock->countPeople();
    double extraChance = source->enemyTargetChance();
    double weight = enemyPopulation * (extraChance / (1 - extraChance));
    double totalWeight = population() - enemyPopulation + weight;
    double roll = (double)qrand() / RAND_MAX;
    if(roll <= weight / totalWeight){
        if(enemyBlock->applyFanaticAction()){
            return;
        }
    }

    for(auto g:_groups){
        if(g != enemyBlock){
            weight += g->countPeople();
            if(roll <= weight / totalWeight){
                if(g->applyFanaticAction()){
                    return;
                }
            }
        }
    }

    emit extinction();
}

QQmlListProperty<PoliticalGroup> SomeCountry::groups(){
    return QQmlListProperty<PoliticalGroup>(this,nullptr,&SomeCountry::addGroup,
                                                             &SomeCountry::countGroups,
                                                             &SomeCountry::getGroup,
                                                             &SomeCountry::resetGroups);
}

void SomeCountry::addGroup(QQmlListProperty<PoliticalGroup> *property, PoliticalGroup *group){
    auto obj = qobject_cast<SomeCountry*>(property->object);
    if(obj){
        obj->_groups.append(group);
    }
}

PoliticalGroup *SomeCountry::getGroup(QQmlListProperty<PoliticalGroup> *property, int index){
    auto obj = qobject_cast<SomeCountry*>(property->object);
    if(obj){
        return obj->_groups.at(index);
    }
    return nullptr;
}

int SomeCountry::countGroups(QQmlListProperty<PoliticalGroup> *property){
    auto obj = qobject_cast<SomeCountry*>(property->object);
    if(obj){
        return obj->_groups.count();
    }
    return 0;
}

void SomeCountry::resetGroups(QQmlListProperty<PoliticalGroup> *property){
    auto obj = qobject_cast<SomeCountry*>(property->object);
    if(obj){
        obj->_groups.clear();
    }
}
