import QtQuick 2.0
import QtQuick.Controls 2.2

Item{
    width: parent.width * 0.3
    Column{
        id: statsColumn
        width: parent.width
        spacing: 5
        Row{
            height: children.implicitHeight
            Text {
                width: statsColumn.width * 0.7
                text: "Уровень влияния"
            }
            Text{
                text: controlledGroup.agitationPower
            }
        }
        Row{
            height: children.implicitHeight
            Text {
                width: statsColumn.width * 0.7
                text: "Фанатики"
            }
            Text{
                text: controlledGroup.fans
            }
        }
        Row{
            height: children.implicitHeight
            Text {
                width: statsColumn.width * 0.7
                text: "Олигархи"
            }
            Text{
                text: controlledGroup.oligarhs
            }
        }
        Row{
            height: children.implicitHeight
            Text {
                width: statsColumn.width * 0.7
                text: "Свободные средства"
            }
            Text{
                text: controlledGroup.budget
            }
        }
        Column{
            visible: controlledByUser
            width: parent.width
            height: implicitHeight
            spacing: 5
            Repeater{
                id:actions
                model: controlledGroup.actionList.allowedActions
                Button{
                    id: button
                    width: statsColumn.width
                    text: modelData.title
                    property var source: modelData
                    enabled: source.cost <= controlledGroup.budget
                    onClicked:{
                        controlledGroup.actionList.performAction(index,controlledGroup)
                    }
                    contentItem: Text {
                        id: buttonText
                        text: button.text
                        font: button.font
                        opacity: enabled ? 1.0 : 0.3
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: buttonText.implicitHeight
                        opacity: enabled ? 1 : 0.3
                        color: button.down ? "silver" : "lightgray"
                        border.width: 1
                        radius: 5
                    }
                }
            }
        }
    }

    property var controlledGroup
    property bool controlledByUser: false

}
