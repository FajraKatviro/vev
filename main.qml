import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import modules.vev 1.0

Window {
    id: rootWindow
    visible: true
    width: 1334
    height: 750
    title: "VEV"

    property bool useRemoteSettings: true

    Loader {
        id: remoteRoot
        anchors.fill: parent
        property string loadingIp: "46.149.44.200"
        property string loadingPort: "8787"
        property string host: useRemoteSettings ? "http://" + loadingIp + ":" + loadingPort : "file://" + resourceDir + "/rawContent"
        active: false
        source: host + "/VevGame.qml"
    }

    Dialog{
        id: ipSelector
        title:"Sorry, I have no static IP, so enter my current one, please"
        TextField{
            id:inputField
            text: "46.149.44.200"
        }
        standardButtons: StandardButton.Ok
        onAccepted: {
            remoteRoot.loadingIp = inputField.text
            remoteRoot.active = true
        }
    }

    Component.onCompleted:{
        if(useRemoteSettings)
            ipSelector.open()
        else
            remoteRoot.active = true
    }
}
