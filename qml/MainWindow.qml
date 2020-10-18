import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: applicationWindow
    minimumWidth: 600
    minimumHeight: 400

    title: "TBM Desktop"
    visible: true

    property var rendering: false
    signal startRender(input: url, output: url)
    width: 640

    FileDialog {
        id: songFileDialog
        title: "Open Song"
        folder: shortcuts.home
        selectMultiple: false
        nameFilters: ["Audio files (*.mp3 *.wav)", "All files (*)"]
    }

    ColumnLayout {
        id: editorRoot
        spacing: 24
        anchors.rightMargin: 24
        anchors.leftMargin: 24
        anchors.bottomMargin: 20
        anchors.topMargin: 20
        anchors.fill: parent
        Layout.fillHeight: true
        Layout.fillWidth: true

        ColumnLayout {
            id: info
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.columnSpan: 2
            Layout.fillWidth: true
            spacing: 8
            Label {
                text: "TBM Desktop"
                topPadding: 0
                font.pixelSize: 28
            }

            Label {
                text: 'Version'
                onLinkActivated: Qt.openUrlExternally(link)
                font.pixelSize: 14
            }
        }

        RowLayout {
            id: editorColumns
            width: 100
            height: 100
            spacing: 24
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: ioColumn
                spacing: 16
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                ColumnLayout {
                    id: inputConfig
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.maximumWidth: 300

                    Label {
                        text: "Song Input"
                        topPadding: 0
                        font.pixelSize: 16
                    }

                    RowLayout {
                        Button {
                            text: "Browse..."
                            onClicked: songFileDialog.open()
                            enabled: !rendering
                        }

                        TextField {
                            id: songFileField
                            readOnly: true
                            enabled: !rendering
                            Layout.fillWidth: true
                            layer.enabled: false
                            transformOrigin: Item.Center
                        }
                    }

                    CheckBox {
                        id: guessBpm
                        text: qsTr("Guess BPM")
                    }

                    SpinBox {
                        id: minBpm
                        Layout.fillWidth: true
                    }

                    SpinBox {
                        id: maxBpm
                        Layout.fillWidth: true
                    }


                }

                ColumnLayout {
                    id: renderConfig
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.maximumWidth: 300

                    ColumnLayout {
                        Label {
                            text: "Render"
                            topPadding: 0
                            font.pixelSize: 16
                        }
                        RowLayout {
                            Button {
                                text: "Render..."
                                enabled: songFileDialog.fileUrl != ""
                                onClicked: {
                                    saveDialog.open()
                                }
                            }

                            BusyIndicator {
                                id: renderStatus
                                width: 48
                                height: 48
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                id: effectsColumn
                width: 100
                height: 100
                spacing: 8
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.rowSpan: 2
                Layout.columnSpan: 1

                Label {
                    text: "Effect Chain"
                    font.pixelSize: 16
                }

                ListView {
                    id: listView
                    width: 110
                    height: 160
                    pixelAligned: true
                    clip: true
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    contentHeight: 196
                    spacing: 8
                    delegate: Item {
                        width: 80
                        height: 40
                        Row {
                            id: row1
                            anchors.fill: parent
                            spacing: 10

                            Rectangle {
                                id: rectangle
                                color: "#ffffff"
                                anchors.fill: parent
                                border.width: 2

                                Text {
                                    text: name
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.fill: parent
                                    font.bold: false
                                }
                            }
                        }
                    }
                    model: ListModel {
                        ListElement {
                            name: "Swap" // TODO
                        }
                    }
                }

                Button {
                    id: button
                    text: "\ue109"
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    font.family: "Segoe MDL2 Assets"
                }
            }







        }


    }

    FileDialog {
        id: saveDialog
        title: "Save Song"
        folder: shortcuts.home
        selectExisting: false
        nameFilters: ["MP3 audio (*.mp3)"]

        onAccepted: {
            rendering = true
            startRender(songFileDialog.fileUrl, saveDialog.fileUrl)
        }
    }


}




