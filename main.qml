import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import vev 1.0

Window {
    id: rootWindow
    visible: true
    width: 640
    height: 480
    title: "VEV"

    property Timer timer: Timer{
        repeat: true
        interval: 1000 * mainSettings.frameDuration
        running: true//mainSettingsLoader.status == Loader.Ready
        triggeredOnStart: false
        onTriggered: {
            location.performFinancialActions()
            location.performAgitationActions()
            location.performFanaticActions()
        }
    }

    property SomeCountry location: SomeCountry{
        groups: [ neutralGroup, group0, group1 ]

        property int budget: 0

        property PoliticalGroup neutrals: PoliticalGroup{
            id: neutralGroup
            peopleGroups: [ workersGroup, oligarhGroup ]

            property PeopleGroup workers: PeopleGroup{
                id: workersGroup
                people: mainSettings.startPopulation
            }

            property PeopleGroup oligarhs: PeopleGroup{
                id: oligarhGroup
                people: mainSettings.oligarhResidents
            }
        }

        property PoliticalGroup power0: PoliticalPower{
            id: group0
            enemyGroup: group1
        }

        property PoliticalGroup power1: PoliticalPower{
            id: group1
            enemyGroup: group0
        }
        function performFinancialActions(){
            budget += workersGroup.people * mainSettings.taxes
            var groups = [ group0, group1 ]
            for(var i=0; i < groups.length; ++i){
                var group = groups[i]
                var money = Math.min( group.oligarhs * mainSettings.bribe, budget )
                budget -= money
                group.budget += money
            }
        }

        function performAgitationActions(){
            var groups = [ group0, group1 ]
            for(var i=0; i < groups.length; ++i){
                var group = groups[i]
                var recruts = Math.min( group.agitationPower, workersGroup.people )
                workersGroup.people -= recruts
                group.fans += recruts
            }
        }

    }

    Rectangle{
        id: root
        Row{
            Column{
                width: 200
                Text{
                    text: group0.fans
                }
                Text{
                    text: group0.oligarhs
                }
                Text{
                    text: group0.budget
                }
            }

            Column{
                width: 200
                Text{
                    text: workersGroup.people
                }
                Text{
                    text: oligarhGroup.people
                }
                Text{
                    text: location.budget
                }
            }


            Column{
                width: 200
                Text{
                    text: group1.fans
                }
                Text{
                    text: group1.oligarhs
                }
                Text{
                    text: group1.budget
                }
            }

            Column{
                width: 200
                Repeater{
                    id:actions
                    model: actionList.allowedActions
                    Button{
                        text: modelData.title
                        property PoliticalAction source: modelData
                        enabled: source.cost <= group1.budget
                        onClicked:{
                            actionList.performAction(index,group1)
                        }
                    }
                }
            }

        }
    }

    function inviteOligarhs(count,group){
        var oligarhs = Math.min( count, oligarhGroup.people )
        group.oligarhs += oligarhs
        oligarhGroup.people -= oligarhs
    }

    property var actionList: PoliticalActionList {}
    property var mainSettings: MainSettings { }





    property Loader mainSettingsLoader: Loader{
        source: "http://localhost:8080/MainSettings.qml"
    }

    property Loader actionListLoader: Loader{
        source: "http://localhost:8080/PoliticalActionList.qml"
    }

    Binding{
        target: rootWindow
        property: 'mainSettings'
        value: mainSettingsLoader.item
        when: mainSettingsLoader.status === Loader.Ready
    }

    Binding{
        target: rootWindow
        property: 'actionList'
        value: actionListLoader.item
        when: actionListLoader.status === Loader.Ready
    }

}
