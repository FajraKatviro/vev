import QtQuick 2.7
import QtQuick.Window 2.2
import modules.vev 1.0

PoliticalGroup{
    peopleGroups: [ fanaticGroup, oligarhGroup ]

    enemyTargetChance: mainSettings.enemyTargetChance
    performFanaticActionChance: mainSettings.performFanaticActionChance

    property int agitationPower: 0
    property int budget: 0

    property alias fans: fanaticGroup.people
    property alias oligarhs: oligarhGroup.people

    fanatics: PeopleGroup{
        id: fanaticGroup
    }

    property PeopleGroup oligarhsProperty: PeopleGroup{
        id: oligarhGroup
    }

}
