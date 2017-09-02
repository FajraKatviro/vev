import QtQml 2.2

QtObject{
    property double frameDuration: 1.0 //seconds
    property int startPopulation: 423720 //worker residents
    property int oligarhResidents: 50 //total oligarh count in the country
    property double taxes: 0.08 //budget income per worker per frame
    property int bribe: 1000 //founds income per oligarh per frame
    property double performFanaticActionChance: 0.1 //chance to perfrom murder actions per fanatic per frame
    property double enemyTargetChance: 0.9 //chance select target from opposition (not neutral or self)
}
