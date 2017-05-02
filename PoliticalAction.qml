import QtQml 2.2

QtObject{
    property string title
    property string description
    property int cost: 0
    signal trigger(var group)
}
