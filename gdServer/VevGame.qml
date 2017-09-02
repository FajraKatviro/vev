import QtQuick 2.9
import QtQuick.Controls 2.2
import modules.vev 1.0
import "." as Configured

Rectangle{
    id: root
    anchors.fill: parent

    Item{
        id: mainMenu
        anchors.fill: parent
        Text {
            id: mainMenuLabel
            text: "Выберите, на чьей вы стороне"
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 12
            }
            height: parent.height * 0.2
            font.pointSize: 50
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
        Button{
            text: "Политические силы"
            font.pointSize: 50
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: "red"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            anchors{
                top: mainMenuLabel.bottom
                left: mainMenuLabel.left
            }
            height: parent.height * 0.5
            width: mainMenuLabel.width * 0.5 - 6
        }
        Button{
            text: "Политические силы"
            font.pointSize: 50
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: "red"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            anchors{
                top: mainMenuLabel.bottom
                right: mainMenuLabel.right
            }
            height: parent.height * 0.5
            width: mainMenuLabel.width * 0.5 - 6
        }
    }

    Row{
        visible: false
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
                    property var source: modelData
                    enabled: source.cost <= group1.budget
                    onClicked:{
                        actionList.performAction(index,group1)
                    }
                }
            }
        }

    }

    property bool isGameRunning: false
    property Timer timer: Timer{
        repeat: true
        interval: 1000 * mainSettings.frameDuration
        running: isGameRunning
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

    function inviteOligarhs(count,group){
        var oligarhs = Math.min( count, oligarhGroup.people )
        group.oligarhs += oligarhs
        oligarhGroup.people -= oligarhs
    }

    property var mainSettings: Configured.MainSettings {}
    property var actionList: Configured.PoliticalActionList {}

}
