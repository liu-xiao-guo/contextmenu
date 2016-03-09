import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItems

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "contextmenu.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(60)
    height: units.gu(85)

    Page {
        title: i18n.tr("contextmenu")

        // The model:
        ListModel {
            id: fruitModel

            objectName: "fruitModel"

            ListElement {
                name: "Apple"; cost: 2.45
                image: "pics/apple.jpg"
                description: "Deciduous"
            }
            ListElement {
                name: "Banana"; cost: 1.95
                image: "pics/banana.jpg"
                description: "Seedless"
            }
            ListElement {
                name: "Cumquat"; cost: 3.25
                image: "pics/cumquat.jpg"
                description: "Citrus"
            }
            ListElement {
                name: "Durian"; cost: 9.95
                image: "pics/durian.jpg"
                description: "Tropical Smelly"
            }
        }

        Component {
            id: listDelegate

            ListItem {
                id: delegateItem
                width: listView.width; height: units.gu(10)
                onPressAndHold: ListView.view.ViewItems.dragMode =
                                !ListView.view.ViewItems.dragMode

                Image {
                    id: pic
                    height: parent.height - units.gu(1)
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(0.5)
                    source: image
                }

                Column {
                    id: content
                    anchors.top: parent.top
                    anchors.left: pic.right
                    anchors.leftMargin: units.gu(2)
                    anchors.topMargin: units.gu(1)
                    width: parent.width - pic.width - units.gu(1)
                    height: parent.height
                    spacing: units.gu(1)

                    Label {
                        text: name
                    }

                    Label { text: description }

                    Label {
                        text: '$' + Number(cost).toFixed(2)
                        font.bold: true
                    }
                }


                ListView.onAdd: SequentialAnimation {
                    PropertyAction { target: delegateItem; property: "height"; value: 0 }
                    NumberAnimation { target: delegateItem; property: "height"; to: delegateItem.height; duration: 250; easing.type: Easing.InOutQuad }
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
                    NumberAnimation { target: delegateItem; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }

                    // Make sure delayRemove is set back to false so that the item can be destroyed
                    PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
                }

                /* create an empty item centered in the image to align the popover to */
                Item {
                    id: emptyItemForCaller
                    anchors.centerIn: parent
                    z: 100

                }

                Component {
                    id: actPopComp

                    ActionSelectionPopover {
                        id: actPop
                        delegate: ListItems.Standard {
                            text: action.text
                        }

                        actions: ActionList {
                            Action {
                                text: "Add 1 dollar"
                                iconName: "add"
                                onTriggered: {
                                    PopupUtils.close(actPop);
                                    console.log("Add 1 dollar");
                                    fruitModel.setProperty(index, "cost", cost + 1.0);
                                }
                            }
                            Action {
                                text: "Deduct 1 dollar"
                                iconName: "remove"
                                onTriggered: {
                                    PopupUtils.close(actPop);
                                    console.log("Deduct 1 dollar");
                                    fruitModel.setProperty(index, "cost", Math.max(0,cost-1.0));
                                }
                            }
                            Action {
                                text: "delete"
                                iconName: "delete"

                                onTriggered: {
                                    console.log("delete the item!");
                                    fruitModel.remove(index)
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: {
                        PopupUtils.open(actPopComp, emptyItemForCaller);
                    }

                    onClicked: {
                        console.log("we can do something else!");
                    }
                }
            }
        }

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 20
            model: fruitModel
            delegate: listDelegate
        }
    }
}
