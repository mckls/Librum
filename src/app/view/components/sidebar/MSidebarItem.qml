import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FocusScope
{
    id: root
    implicitWidth: (labelVisibility ? openedWidth : closedWidth)
    implicitHeight: 44
    
    property int closedWidth : 52
    property int openedWidth : 177
    property int imageWidth : 30
    property int imageHeight : 30
    property string imageSource : ""
    property string labelContent : "Content here"
    property alias  labelVisibility : label.visible
    property alias  openAnimation : openAnim
    property alias  closeAnimation : closeAnim
    property real   textOpacity : 0
    property bool   selected : false
    
    signal clicked()
    
    Rectangle
    {
        id: content
        width:  root.closedWidth
        height: parent.height
        color: (root.selected == true ? properties.colorSidebarMark : "transparent")
        radius: 4
        
        RowLayout
        {
            height: parent.height
            spacing: 0
            
            Rectangle
            {
                Layout.preferredWidth: 52
                Layout.preferredHeight: 44
                radius: 4
                color: "transparent"
                
                Image
                {
                    sourceSize.height: root.imageHeight
                    sourceSize.width: root.imageWidth
                    anchors.centerIn: parent
                    source: root.imageSource
                    antialiasing: false                    
                }
            }
            
            Label
            {
                id: label
                Layout.leftMargin: 10
                visible: false
                opacity: root.textOpacity
                text: root.labelContent
                font.family: properties.defaultFontFamily
                font.weight: Font.Medium
                font.pointSize: 13
                color: properties.colorLightText3
            }
        }
    }
    
    MouseArea
    {
        anchors.fill: parent
        onClicked: root.clicked();
    }
    
    PropertyAnimation
    {
        id: openAnim
        target: content
        property: "width"
        to: openedWidth
        duration: 250
        easing.type: Easing.InOutQuad
    }
    
    PropertyAnimation
    {
        id: closeAnim
        target: content
        property: "width"
        to: closedWidth
        duration: 250
        easing.type: Easing.InOutQuad
    }
}