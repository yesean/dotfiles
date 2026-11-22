// Modified from sddm-astronaut-theme (Keyitdev, GPLv3+): styled like the login
// fields, with a chevron so it reads as a dropdown.

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: sessionButton

    height: root.font.pointSize * 3
    width: parent.width / 3

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property ComboBox exposeSession: selectSession

    ComboBox {
        id: selectSession

        height: root.font.pointSize * 3
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        hoverEnabled: true
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        Keys.onPressed: function(event) {
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open();
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.PointingHandCursor
        }

        delegate: ItemDelegate {
            width: popupHandler.width - 20
            anchors.horizontalCenter: popupHandler.horizontalCenter

            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: model.name
                font.bold: true
                font.family: root.font.family
                color: config.DropdownTextColor
            }

            background: Rectangle {
                radius: (config.RoundCorners || 0) / 2
                color: selectSession.highlightedIndex === index ? config.DropdownSelectedBackgroundColor : "transparent"
            }
        }

        indicator: Canvas {
            id: chevron

            x: selectSession.width - width - root.font.pointSize * 1.5
            y: (selectSession.height - height) / 2
            width: root.font.pointSize * 1.1
            height: width * 0.6

            property color strokeColor: displayedItem.color
            onStrokeColorChanged: requestPaint()
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.strokeStyle = strokeColor;
                ctx.lineWidth = Math.max(2, width / 6);
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.beginPath();
                ctx.moveTo(ctx.lineWidth, ctx.lineWidth);
                ctx.lineTo(width / 2, height - ctx.lineWidth);
                ctx.lineTo(width - ctx.lineWidth, ctx.lineWidth);
                ctx.stroke();
            }
        }

        contentItem: Text {
            id: displayedItem

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: selectSession.currentText
            color: config.LoginFieldTextColor
            font.bold: true
            font.family: root.font.family
            renderType: Text.QtRendering

            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: config.LoginFieldBackgroundColor
            opacity: 0.2
            border.color: "transparent"
            border.width: parent.visualFocus ? 2 : 1
            radius: config.RoundCorners || 0
        }

        popup: Popup {
            id: popupHandler

            implicitHeight: contentItem.implicitHeight
            width: selectSession.width
            // sits at the bottom of the screen, so open upward
            y: -height - 6
            x: 0
            padding: 10

            contentItem: ListView {
                implicitHeight: contentHeight + 20

                clip: true
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: (config.RoundCorners || 0) / 2
                color: config.DropdownBackgroundColor
                layer.enabled: true
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: Qt.darker(config.HoverSessionButtonTextColor, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
            }
        ]
        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color"
                    duration: 150
                }
            }
        ]

    }

}
