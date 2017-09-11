import QtQuick 2.0
import QtQuick.Controls 2.2

Item{

    property int cellWidth: 300

    Row{
        id: statsColumn
        anchors.centerIn: parent
        spacing: 5
        Text {
            width: cellWidth * 0.7
            text: "Рабочее население"
        }
        Text{
            width: cellWidth * 0.3
            text: sourceGroup.workers.people
        }
        Text {
            width: cellWidth * 0.7
            text: "Олигархи"
        }
        Text{
            width: cellWidth * 0.3
            text: sourceGroup.oligarhs.people
        }
        Text {
            width: cellWidth * 0.7
            text: "Государственный бюджет"
        }
        Text{
            width: cellWidth * 0.3
            text: location.budget
        }
    }

    property var sourceGroup
}
