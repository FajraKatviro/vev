import QtQuick 2.9
import modules.vev 1.0

QtObject{
    property PoliticalGroup target: null
    readonly property int skipFrames: mainSettings.autoplayerLatency
    property int frameCounter: 0
    function perfromPlayerActions(){
        if (target === null)
            return
        if (++frameCounter < skipFrames)
            return
        frameCounter = 0
        var size = target.actionList.allowedActions.length
        var actions = []
        for(var i=0; i<size; ++i){
            var action = target.actionList.allowedActions[i]
            if (action.cost <= target.budget){
                actions.push(i)
            }
        }
        size = actions.length
        if (size > 0){
            var selectedAction = Math.floor(Math.random() * size)
            target.actionList.performAction(actions[selectedAction],target)
        }
    }
}
