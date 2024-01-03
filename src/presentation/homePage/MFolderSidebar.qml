import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.controllers
import Librum.style

Item {
    id: foldersSidebar
    property bool opened: false
    property int openedWidth: 260

    width: 0


    /*
      Adds a border to the whole settings sidebar
     */
    Rectangle {
        id: background
        anchors.fill: parent
        color: Style.colorSettingsSidebarBackground

        Rectangle {
            id: rightBorder
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: Style.colorContainerBorder
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 0

        Pane {
            id: treeViewContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            verticalPadding: 6
            horizontalPadding: 4
            background: Rectangle {
                color: "transparent"
            }

            ScrollView {
                id: scrollBar
                property bool isEnabled: contentHeight > height
                anchors.fill: parent

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                onIsEnabledChanged: {
                    if (isEnabled)
                        ScrollBar.vertical.policy = ScrollBar.AlwaysOn
                    else
                        ScrollBar.vertical.policy = ScrollBar.AlwaysOff
                }

                TreeView {
                    id: treeView
                    property int indent: 18

                    anchors.fill: parent
                    anchors.margins: 1
                    anchors.rightMargin: scrollBar.isEnabled ? 18 : 1
                    clip: true
                    focus: true

                    delegate: Rectangle {
                        id: treeNode
                        required property string title
                        required property int pageNumber
                        required property TreeView treeView
                        required property bool expanded
                        required property int hasChildren
                        required property int depth

                        implicitWidth: treeView.width - 2 // L/R margins
                        width: implicitWidth
                        implicitHeight: treeNodeLabel.height
                        color: "transparent"

                        RowLayout {
                            id: nodeLayout
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 0

                            Image {
                                id: indicator
                                Layout.preferredWidth: implicitWidth
                                Layout.leftMargin: treeNode.depth * treeView.indent
                                Layout.alignment: Qt.AlignVCenter
                                visible: treeNode.hasChildren
                                opacity: pageSwitchTrigger.pressed
                                         || indicatorArea.pressed ? 0.7 : 1
                                source: Icons.arrowheadNextIcon
                                sourceSize.width: 20
                                fillMode: Image.PreserveAspectFit
                                rotation: treeNode.expanded ? 90 : 0

                                MouseArea {
                                    id: indicatorArea
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: treeView.toggleExpanded(row)
                                }
                            }

                            Text {
                                id: treeNodeLabel
                                Layout.fillWidth: true
                                Layout.leftMargin: treeNode.hasChildren ? indicator.width * 0.1 : indicator.width * 1.1 + depth * treeView.indent
                                Layout.alignment: Qt.AlignVCenter
                                clip: true
                                color: Style.colorText
                                opacity: pageSwitchTrigger.pressed ? 0.7 : 1
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                text: treeNode.title

                                MouseArea {
                                    id: pageSwitchTrigger
                                    anchors.fill: parent

                                    // NaN check: x !== x
                                    onClicked: root.switchPage(
                                                   model.pageNumber,
                                                   model.yOffset
                                                   !== model.yOffset ? 1 : model.yOffset - 10)
                                }
                            }

                            Text {
                                id: pageNumberLabel
                                Layout.preferredWidth: implicitWidth
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.leftMargin: 6
                                color: Style.colorText
                                opacity: pageSwitchTrigger.pressed ? 0.7 : 1
                                font.pixelSize: 14
                                text: treeNode.pageNumber
                                      + 1 // Convert from 0-indexed to normal numbers
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    // contentItem is the TreeView's underlying Flickable
                    contentItem.flickDeceleration = 10000
                    contentItem.maximumFlickVelocity = 2000
                    contentItem.boundsBehavior = Flickable.StopAtBounds
                    contentItem.boundsMovement = Flickable.StopAtBounds
                }
            }
        }
    }

    function open() {
        opened = true
        width = openedWidth
    }

    function close() {
        opened = false
        width = 0
    }

    function toggle() {
        if (opened)
            close()
        else
            open()
    }
}
