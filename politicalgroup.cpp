#include "politicalgroup.h"

PoliticalGroup::PoliticalGroup(QObject *parent) : QObject(parent)
{

}

int PoliticalGroup::countFanaticActions() const{
    if(!_fanatics){
        return 0;
    }
    double chance = performFanaticActionChance();
    int fans = _fanatics->people();
    int actions = fans * chance;
    if(!actions){
        int p = _fanatics->people();
        for(int i=0; i < p; ++i){
            double roll = (double)qrand() / RAND_MAX;
            if(roll <= chance){
                ++actions;
            }
        }
    }
    actions = std::min( std::max(actions, 100), fans );
    return actions;
}

PoliticalGroup* PoliticalGroup::enemyGroup() const{
    return _enemyGroup;
}

double PoliticalGroup::enemyTargetChance() const{
    return 0.9;
}

double PoliticalGroup::performFanaticActionChance() const{
    return 0.1;
}

PeopleGroup *PoliticalGroup::fanatics() const{
    return _fanatics;
}

int PoliticalGroup::countPeople() const{
    int p = 0;
    for(auto g:_peopleGroups){
        p += g->people();
    }
    return p;
}

bool PoliticalGroup::applyFanaticAction(){
    double fullWeight = countPeople();
    if(!fullWeight){
        return false;
    }
    double weight = 0;
    double roll = (double)qrand() / RAND_MAX;
    for(auto g:_peopleGroups){
        weight += g->people();
        if(roll <= weight / fullWeight){
            if(g->reduce()){
                return true;
            }
        }
    }
    return false;
}

void PoliticalGroup::setEnemyGroup(PoliticalGroup *arg){
    if(_enemyGroup != arg){
        _enemyGroup = arg;
        emit enemyGroupChanged();
    }
}

void PoliticalGroup::setFanatics(PeopleGroup *arg){
    if(_fanatics != arg){
        _fanatics = arg;
        emit fanaticsChanged();
    }
}

QQmlListProperty<PeopleGroup> PoliticalGroup::peopleGroups(){
    return QQmlListProperty<PeopleGroup>(this,nullptr,&PoliticalGroup::addPeopleGroup,
                                                          &PoliticalGroup::countPeopleGroups,
                                                          &PoliticalGroup::getPeopleGroup,
                                             &PoliticalGroup::resetPeopleGroups);
}

void PoliticalGroup::addPeopleGroup(QQmlListProperty<PeopleGroup> *property, PeopleGroup *group){
    auto obj = qobject_cast<PoliticalGroup*>(property->object);
    if(obj){
        obj->_peopleGroups.append(group);
    }
}

PeopleGroup *PoliticalGroup::getPeopleGroup(QQmlListProperty<PeopleGroup> *property, int index){
    auto obj = qobject_cast<PoliticalGroup*>(property->object);
    if(obj){
        return obj->_peopleGroups.at(index);
    }
    return nullptr;
}

int PoliticalGroup::countPeopleGroups(QQmlListProperty<PeopleGroup> *property){
    auto obj = qobject_cast<PoliticalGroup*>(property->object);
    if(obj){
        return obj->_peopleGroups.count();
    }
    return 0;
}

void PoliticalGroup::resetPeopleGroups(QQmlListProperty<PeopleGroup> *property){
    auto obj = qobject_cast<PoliticalGroup*>(property->object);
    if(obj){
        obj->_peopleGroups.clear();
    }
}
