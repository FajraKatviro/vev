#ifndef PEOPLEGROUP_H
#define PEOPLEGROUP_H

#include <QObject>

class PeopleGroup : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int people READ people WRITE setPeople NOTIFY peopleChanged)
public:
    explicit PeopleGroup(QObject *parent = 0);

    int people()const;

    bool reduce();

signals:
    void peopleChanged();

public slots:

private:
    void setPeople(int arg);
    int _people = 0;

};

#endif // PEOPLEGROUP_H
