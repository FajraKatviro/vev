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
            onClicked: {
                player0.controlledByUser = true
                mainMenu.visible = false
                hintPopup.visible = true
            }
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
            onClicked: {
                player1.controlledByUser = true
                mainMenu.visible = false
                hintPopup.visible = true
            }
        }
    }

    Item{
        id: hintPopup
        anchors.fill: parent
        visible: false
        Text{
            id: hintText
            width: 300
            anchors.centerIn: parent
            text: "Проводите политические акции для укрепления позиции в обществе.\n\n" +
                  "Привлекайте влиятельных лиц для увеличения финансирования, распределяемого на политические нужды.\n\n" +
                   "Чем выше ваша политическая сила, тем больше последователей захочет к вам присоединиться.\n\n" +
                   "Ваши последователи будут стоять за ваше дело до конца и попытаются сокрушить оппозиционные силы любыми доступными способами. " +
                   "К сожалению, как и в любом большом деле, в серьезной политической борьбе неизбежно будут происходить и случайные потери. " +
                   "Тем не менее, это не должно отвлекать вас от главной цели."

            verticalAlignment: Text.AlignVCenter
            //horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
        Button{
            anchors{
                horizontalCenter: hintText.horizontalCenter
                top: hintText.bottom
                topMargin: 50
            }
            text: "Вперёд!"
            onClicked:{
                hintPopup.visible = false
                startGame()
            }
        }
    }

    Item{
        id: gameScreen
        anchors.fill: parent
        visible: false

        Configured.PlayerView{
            id: player0
            anchors.left: parent.left
            controlledGroup: group0
        }

        Configured.PlayerView{
            id: player1
            anchors.right: parent.right
            controlledGroup: group1
        }

        Configured.CountryView{
            id: countryView
            height: parent.height * 0.1
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            sourceGroup: neutralGroup
        }

        Rectangle{
            anchors{
                top: parent.top
                left: player0.right
                right: player1.left
                bottom: countryView.top
            }
            color: "yellow"
            Text{
                anchors.centerIn: parent
                text: "Карта Какого-то государства"
            }
        }

    }

    Item{
        id: loosePopup
        anchors.fill: parent
        visible: false
        Rectangle{
            id: loosePopupBg
            anchors.fill: parent
            color: loosePopup.visible ? "black" : "transparent"
            Text {
                anchors.centerIn: parent
                width: parent.width * 0.7
                color: "white"
                text: "Политическая сила победила: все граждане умерли.\nВозможно, в следующий раз вы предпочтёте жизни людей, а не политику?"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
            }
            Behavior on color {
                ColorAnimation{ duration: 1000 }
            }
        }
    }

    function startGame(){
        gameScreen.visible = true
        isGameRunning = true
    }

    function endGame(){
        gameScreen.visible = false
        loosePopup.visible = true
        isGameRunning = false
    }

    property bool isGameRunning: false
    property Timer mainTimer: Timer{
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

        onExtinction: endGame()

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
            property var actionList: Configured.PoliticalActionList {}
        }

        property PoliticalGroup power1: PoliticalPower{
            id: group1
            enemyGroup: group0
            property var actionList: Configured.PoliticalActionList {}
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

}
