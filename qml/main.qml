import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: "The Beat Machine"
    visible: true
    minimumWidth: 600
    minimumHeight: 400

    property var rendering: false
    signal startRender(file: url)

    FileDialog {
        id: songFileDialog
        title: "Open Song"
        folder: shortcuts.music
        selectMultiple: false
        nameFilters: ["Audio files (*.mp3)", "All files (*)"]
    }

    GridLayout {
        anchors.fill: parent 
        columns: 2

        RowLayout {
            Button {
                text: "Browse..."
                onClicked: songFileDialog.open()
                enabled: !rendering
            }

            TextField {
                id: songFileField
                width: parent.width
                readOnly: true
                enabled: !rendering
                Layout.fillWidth: true
                text: songFileDialog.fileUrl
            }
        }

        RowLayout {
            Button {
                text: "Render..."
                enabled: songFileDialog.fileUrl != ""
                onClicked: {
                    rendering = true
                    startRender(songFileDialog.fileUrl)
                }
            }

            ProgressBar {

            }
        }
    }
}
