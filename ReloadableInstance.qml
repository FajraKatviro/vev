import QtQuick 2.9

QtObject{
    default property Component source
    property var instance: source.createObject(this)
    function reload(){
        instance.destroy()
        instance = source.createObject(this)
    }
}
