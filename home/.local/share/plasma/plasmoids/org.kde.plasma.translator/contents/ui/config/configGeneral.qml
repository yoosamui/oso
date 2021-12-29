import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Controls.Private 1.0
import ".."

Item {
    id: configGeneral
    Layout.fillWidth: true
    property string cfg_languages: plasmoid.configuration.languages
    property bool cfg_checkall: plasmoid.configuration.checkall
    property string cfg_engine: plasmoid.configuration.engine
    property var enginemodel: ["google", "yandex", "bing", "apertium"]
    property bool cfg_autodetect: plasmoid.configuration.autodetect

    LangModel {
        id: langModel
    }
    Component.onCompleted: {

        changeEngine()
    }
    Connections {
        target: plasmoid.configuration
        onEngineChanged: {
            changeEngine()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        Layout.alignment: Qt.AlignTop | Qt.AlignRight
        RowLayout {
            Layout.fillWidth: true
            width: parent.width
            Label {
                text: "Translate engine:"
            }
            QQC2.ComboBox {
                id: engine
                model: configGeneral.enginemodel
                currentIndex: engine.model.indexOf(configGeneral.cfg_engine)
                onActivated: configGeneral.cfg_engine = model[index]
            }
            Item {
                Layout.fillWidth: true
            }

            CheckBox {
                id: autosource
                anchors.right: parent.right
                text: "Autodetect source"
                checked: cfg_autodetect
                onClicked: {
                    cfg_autodetect = checked
                }
            }
        }

        Label {
            id: notif
            text: cfg_autodetect ? "Please make sure that at least one language is selected." : "Please make sure that at least two languages are selected."
            //color: PlasmaCore.ColorScope.textColor
        }

        TableView {
            id: langTable
            model: langModel
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Layout.fillHeight: true
            Layout.fillWidth: true

            TableViewColumn {
                title: "👁"
                role: "active"
                width: 30
                horizontalAlignment: Qt.AlignHCenter
                delegate: Item {
                    anchors.fill: parent
                    CheckBox {
                        id: check
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        anchors.centerIn: parent
                        visible: model ? model.enabled : false
                        checked: model ? model.active : false
                        onVisibleChanged: if (visible)
                                              checked = styleData.value
                        onCheckedChanged: {
                            model ? model.active = checked : undefined
                            if (this.checked === false) {
                                configGeneral.cfg_checkall = false
                            }

                            cfg_languages = JSON.stringify(getLanguagesArray())
                            getLangNumbers()
                        }
                    }
                    PlasmaCore.IconItem {
                        source: "error"
                        visible: !check.visible
                        anchors.fill: parent
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill: parent
                            onEntered: {

                            }
                        }
                    }
                }
            }

            TableViewColumn {
                role: "lang"
                title: i18n("Name")
                horizontalAlignment: Qt.AlignHCenter
                delegate: Label {
                    text: styleData.value
                    //color: PlasmaCore.ColorScope.textColor
                    enabled: model ? model.enabled : false
                    horizontalAlignment: Qt.AlignHCenter
                }
            }

            TableViewColumn {
                role: "nativelang"
                title: i18n("Native Name")
                horizontalAlignment: Qt.AlignHCenter
                delegate: Label {
                    text: styleData.value
                    enabled: model ? model.enabled : false
                    horizontalAlignment: Qt.AlignHCenter
                }
            }

            TableViewColumn {
                role: "code"
                title: i18n("Code")
                width: 125
                horizontalAlignment: Qt.AlignHCenter
                delegate: Label {
                    text: styleData.value
                    enabled: model ? model.enabled : false
                    horizontalAlignment: Qt.AlignHCenter
                }
            }
            onClicked: {
                moveUp.enabled = true
                moveDown.enabled = true
            }
        }
        RowLayout {
            id: buttonsRow
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true

            CheckBox {
                id: checkAll
                text: this.checked ? i18n("Uncheck all") : i18n("Check all")
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignLeft
                Layout.minimumWidth: parent.width / 2

                checked: configGeneral.cfg_checkall
                onClicked: {
                    var i
                    if (this.checked === false) {
                        for (i = 0; i < langModel.count; ++i) {
                            langModel.set(i, {
                                              "active": false
                                          })
                        }
                    } else {
                        for (i = 0; i < langModel.count; ++i) {
                            langModel.set(i, {
                                              "active": true
                                          })
                        }
                    }
                    cfg_languages = JSON.stringify(getLanguagesArray())
                    langModel.clear()
                    var languages = JSON.parse(cfg_languages)
                    for (i = 0; i < languages.length; i++) {
                        langModel.append(languages[i])
                        getLangNumbers()
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: moveUp
                text: i18n("Move up")
                enabled: false
                Layout.fillWidth: false
                onClicked: {
                    if (langTable.currentRow == -1
                            || langTable.currentRow == 0) {
                        this.enabled === false
                        return
                    }
                    langTable.model.move(langTable.currentRow,
                                         langTable.currentRow - 1, 1)
                    langTable.selection.clear()
                    langTable.selection.select(langTable.currentRow - 1)
                    cfg_languages = JSON.stringify(getLanguagesArray())
                }
            }

            Button {
                id: moveDown
                text: i18n("Move down")

                Layout.fillWidth: false
                enabled: false
                onClicked: {
                    if (langTable.currentRow == -1
                            || langTable.currentRow == langTable.model.count - 1) {
                        this.enabled === false
                        return
                    }
                    langTable.model.move(langTable.currentRow,
                                         langTable.currentRow + 1, 1)
                    langTable.selection.clear()
                    langTable.selection.select(langTable.currentRow + 1)
                    cfg_languages = JSON.stringify(getLanguagesArray())
                }
            }
        }
    }

    function getLanguagesArray() {
        var langArray = []
        for (var i = 0; i < langModel.count; i++) {
            langArray.push(langModel.get(i))
        }
        return langArray
    }
    function getLangNumbers() {
        var j = 0
        for (var i = 0; i < langModel.count; i++) {
            if (langModel.get(i).active === true) {
                j = j + 1
            }
        }
        if (j > 1) {
            notif.color = SystemPaletteSingleton.text(enabled)
        } else {
            notif.color = "red"
        }
    }
    function changeEngine() {
        langModel.clear()
        var eng = configGeneral.cfg_engine
        var languages = JSON.parse(cfg_languages)
        for (var i = 0; i < languages.length; i++) {
            langModel.append(languages[i])
            langModel.set(i, {
                              "enabled": true
                          })
        }
        for (var j = 0; j < languages.length; j++) {
            if (langModel.get(j)[eng] === false) {
                langModel.set(j, {
                                  "enabled": false,
                                  "active": false
                              })
            }
        }
    }
}
