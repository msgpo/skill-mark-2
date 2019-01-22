/*
 * Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM
import Mycroft 1.0 as Mycroft

Item {
    id: networkSelectionView
    anchors.fill: parent
    property var pathToRemove
        
    function removeConnection(){
        handler.removeConnection(pathToRemove)
    }
    
    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }

    PlasmaNM.Handler {
        id: handler
    }

    PlasmaNM.AvailableDevices {
        id: availableDevices
    }

    PlasmaNM.NetworkModel {
        id: connectionModel
    }

    PlasmaNM.AppletProxyModel {
        id: appletProxyModel
        sourceModel: connectionModel
    }
    Item {
        id: topArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Kirigami.Units.gridUnit * 2
        
        Kirigami.Heading {
            id: connectionTextHeading
            level: 1
            wrapMode: Text.WordWrap
            anchors.centerIn: parent
            font.bold: true
            text: "Select Your Wi-Fi"
            color: Kirigami.Theme.linkColor
        }
    }

    Item {
        anchors.top: topArea.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomArea.top
        
        ListView {
            id: connectionView
            property bool availableConnectionsVisible: true
            anchors.fill: parent
            clip: true
            model: appletProxyModel
            currentIndex: -1
            boundsBehavior: Flickable.StopAtBounds
            delegate: NetworkItem{}
        }
    }
    
    Item {
        id: bottomArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: backIcon.implicitHeight + Kirigami.Units.largeSpacing
        
        Kirigami.Icon {
            id: backIcon
            source: "go-previous"
            anchors.left: parent.left
            anchors.leftMargin: Kirigami.Units.largeSpacing
            width: Kirigami.Units.iconSizes.large
            height: implicitWidth
            
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    triggerEvent("mycroft.device.settings", {})
                }
            }
        }
    }
    
    Kirigami.OverlaySheet {
        id: networkActions
        leftPadding: 0
        rightPadding: 0
        parent: networkSelectionView
         
        ColumnLayout {
            implicitWidth: Kirigami.Units.gridUnit * 25
            spacing: 0 
         
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Label {
                    anchors.centerIn: parent
                    text: "Forget Network"
                }
                
                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        removeConnection()
                        networkActions.close()
                    }
                }
            }
        }
    }
}
