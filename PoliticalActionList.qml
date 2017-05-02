import QtQml 2.2


QtObject{

    function removeAction(index){
        var actions = []
        for(var i=0; i < allowedActions.length; ++i){
            if(i !== index){
                actions.push(allowedActions[i])
            }
        }
        allowedActions = actions
    }

    function performAction(index,group){
        var action = allowedActions[index]
        group.budget -= action.cost
        action.trigger(group)
        removeAction(index)
    }

    property list<PoliticalAction> allowedActions: [
        PoliticalAction{
            title:"Предложить политическую реформу"
            cost: 0
            onTrigger:{
                inviteOligarhs(10,group)
                group.agitationPower += 100
            }
        },
        PoliticalAction{
            title:"Провести политическую агитацию"
            cost: 80000
            onTrigger:{
                group.agitationPower += 300
            }
        },
        PoliticalAction{
            title:"Объявить политические санкции"
            cost: 120000
            onTrigger:{
                inviteOligarhs(2,group)
                group.agitationPower += 1000
            }
        },
        PoliticalAction{
            title:"Инициировать политическую провокацию"
            cost: 110000
            onTrigger:{
                group.agitationPower *= 1.2
                group.enemyGroup.agitationPower *= 1.1
            }
        }
    ]

}
