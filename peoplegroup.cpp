#include "peoplegroup.h"

PeopleGroup::PeopleGroup(QObject *parent) : QObject(parent)
{

}

int PeopleGroup::people() const{
    return _people;
}

bool PeopleGroup::reduce(){
    if(_people>0){
        --_people;
        emit peopleChanged();
        return true;
    }else{
        return false;
    }
}

void PeopleGroup::setPeople(int arg){
    if(_people != arg){
        _people = arg;
        emit peopleChanged();
    }
}
