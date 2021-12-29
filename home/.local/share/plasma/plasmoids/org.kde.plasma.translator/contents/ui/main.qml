import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2 as QQC2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
//import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Private 1.0
import ".."

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    anchors.centerIn: parent
    width: 600
    height: 300
    property string cfg_languages: plasmoid.configuration.languages
    property string toDelete: ""
    property string lefttext: ""
    property string righttext: ""
    property var langlist: []
    property var codelist: []
    property var detectlist: ["Autodetect"]
    property int sourceIndex: 0
    property int destinationIndex: 1
    property bool ind: false
    property string swapText: ""
    property int swapIndex: 0
    property string imgurl: "../images/icon.svg"
    property string cfg_engine: plasmoid.configuration.engine
    property bool cfg_autodetect: plasmoid.configuration.autodetect
    property bool indlang: false
    property bool pins: false
    property bool pack: true
    property var isRtl: ["ar", "fa", "he", "ps", "sd", "ur", "yi"]

    LangModel {
        id: langModel
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    PlasmaCore.DataSource {
        id: checkpackage
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    PlasmaCore.DataSource {
        id: listen
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    PlasmaCore.DataSource {
        id: detect
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode2 = data["exit code"]
            var exitStatus2 = data["exit status"]
            var stdout2 = data["stdout"]
            var stderr2 = data["stderr"]
            exited(sourceName, exitCode2, exitStatus2, stdout2, stderr2)
            disconnectSource(sourceName)
        }
        function exec(cmd2) {
            if (cmd2) {
                connectSource(cmd2)
            }
        }
        signal exited(string cmd2, int exitCode2, int exitStatus2, string stdout2, string stderr2)
    }
    function checkPackage() {
        checkpackage.exec("trans hello world")
    }

    function detectsource() {
        root.detectlist = []
        var formattedText3 = root.lefttext.replace(/"/g,
                                                   '\\\"').replace("`", "\'")
        detect.exec("trans " + formattedText3 + " -identify")
    }

    function translate() {
        root.ind = true
        var formattedText = root.lefttext.replace(/"/g,
                                                  '\\\"').replace("`", "\'")
        var autod = root.cfg_autodetect == true ? "" : root.codelist[root.sourceIndex]
        executable.exec(
                    "trans {" + autod + "=" + root.codelist[root.destinationIndex]
                    + "} " + " " + "\"" + formattedText + "\"" + " -brief "
                    + "-e " + root.cfg_engine /*+ " -debug"*/
                    )
    }

    function listend(text, it) {
        var formattedText2 = text.replace(/"/g, '\\\"')
        listen.exec("trans " + "\"" + formattedText2 + "\"" + " -play -brief  " + it)
    }
    Connections {
        target: executable
        onExited: {
            var formattedText = stdout.trim()
            var errorText = stderr
            if (isRtl.indexOf(root.destinationIndex) !== -1) {
                formattedText = [formattedText].reverse().join('')
            }
            root.righttext = formattedText.length
                    > 0 ? formattedText : "Unable to translate.\nError: " + errorText

            root.ind = false
        }
    }
    Connections {
        target: checkpackage
        onExited: {
            var formattedText = stdout.trim()
            var errorText = stderr.trim()
            if (errorText.indexOf("trans") !== -1) {
                root.pack = false
            } else {
                root.pack = true
            }
        }
    }

    Connections {
        target: detect
        onExited: {
            var formattedText4 = stdout2.trim()
            var lang = formattedText4.split("\n")[1].replace("[22m",
                                                             "").replace(
                        "Name                  [1m", "").replace("[22m", "")
            var copy = []
            root.detectlist = []
            copy.push(lang)
            root.detectlist = copy
            root.indlang = true
        }
    }

    Component.onCompleted: {
        loadLangModel()
        root.destinationIndex = 1
        checkPackage()
    }

    Connections {
        target: plasmoid.configuration
        onLanguagesChanged: {
            loadLangModel()
            //getLocale()
            root.sourceIndex = 0
            root.destinationIndex = cfg_autodetect ? 0 : 1
        }
    }
    Plasmoid.compactRepresentation: Item {
        id: compRoot
        width: parent.width
        height: parent.width
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        PlasmaCore.IconItem {
            id: ima
            anchors.fill: parent
            source: Qt.resolvedUrl(root.imgurl)
            width: parent.width
            height: parent.height
            ColorOverlay {
                anchors.fill: ima
                source: ima
                color: PlasmaCore.ColorScope.textColor
                antialiasing: true
            }
        }
        MouseArea {
            id: mouseArea
            width: parent.width
            height: parent.width
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded
            }
        }
    }

    Plasmoid.fullRepresentation: Item {

        Plasmoid.onExpandedChanged: {
            if (expanded) {
                time.start()
            }
        }
        Plasmoid.hideOnWindowDeactivate: !root.pins
        id: fullRoot
        width: 600
        height: 300
        enabled: !root.ind
        Layout.fillHeight: true
        Layout.fillWidth: true

        Timer {
            id: time
            onTriggered: {
                leftPanel.forceActiveFocus()
            }
            interval: 200
            running: false
            repeat: false
        }
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            height: parent.height
            width: parent.width
            visible: root.langlist.length > 1 && root.pack == true
            GridLayout {
                columns: 3
                width: parent.width
                Layout.maximumWidth: parent.width

                ColumnLayout {

                    Layout.fillWidth: true
                    Layout.maximumWidth: (parent.width - sw.width) / 2 - units.smallSpacing
                    RowLayout {
                        Layout.fillWidth: true
                        width: parent.width
                        PlasmaComponents.Label {
                            text: "Source"
                            Layout.fillWidth: false
                            Layout.alignment: Qt.AlignLeft | Qt.AlignHCenter
                        }

                        ComboBox3 {
                            id: sourceLang
                            editable: true
                            Layout.fillWidth: true
                            rightPadding: sw.width
                            enabled: !root.cfg_autodetect
                            model: root.cfg_autodetect ? root.detectlist : root.langlist
                            currentIndex: root.cfg_autodetect ? 0 : root.sourceIndex
                            onCurrentIndexChanged: {
                                root.sourceIndex = sourceLang.currentIndex
                            }
                        }

                        PlasmaComponents.ToolButton {
                            id: clearbutton
                            flat: true
                            tooltip: "Clear all (Esc)"
                            iconSource: "edit-clear-all-symbolic"
                            enabled: leftPanel.text.length > 0
                            onClicked: {
                                clear.trigger()
                                root.indlang = false
                            }
                        }
                    }
                    PlasmaComponents.TextArea {
                        id: leftPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumWidth: parent.width
                        text: root.lefttext
                        onTextChanged: {
                            root.lefttext = leftPanel.text
                            if (this.text.length == 0) {
                                var copy = ["Autodetect"]
                                root.detectlist = copy
                                root.indlang = false
                            }
                        }
                    }

                    RowLayout {
                        width: parent.width
                        Layout.minimumWidth: parent.width
                        PlasmaComponents.ToolButton {
                            Layout.fillWidth: false
                            iconSource: "player-volume"
                            tooltip: "Listen"
                            enabled: leftPanel.text.length > 0
                                     && leftPanel.text.length < 5001 ? true : false
                            onClicked: {
                                listend(root.lefttext, "-sp")
                            }
                        }
                        PlasmaComponents.ToolButton {
                            Layout.fillWidth: false
                            transformOrigin: Item.Left
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            iconSource: "edit-paste"
                            enabled: leftPanel.focus
                            tooltip: "Paste (Ctrl+V)"
                            onClicked: {
                                paste.trigger()
                            }
                        }

                        PlasmaComponents.Label {
                            text: leftPanel.text.length + "/5000"
                            Layout.fillWidth: true
                            enabled: leftPanel.text.length > 0
                            color: leftPanel.text.length
                                   > 5000 ? "red" : PlasmaCore.ColorScope.textColor
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    id: sw
                    PlasmaComponents.ToolButton {
                        Layout.fillWidth: false
                        tooltip: "Swap panels (CTRL+S)"
                        iconSource: "document-swap"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        enabled: !cfg_autodetect
                                 && root.sourceIndex !== root.destinationIndex
                        onClicked: {
                            swap.trigger()
                        }
                        BusyIndicator {
                            id: busyIndicator
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            width: parent.width
                            enabled: true
                            running: root.ind
                            visible: root.ind
                        }
                    }
                }

                ColumnLayout {
                    Layout.maximumWidth: (parent.width - sw.width) / 2 - units.smallSpacing
                    Layout.fillWidth: true
                    RowLayout {
                        Layout.minimumWidth: parent.width
                        width: parent.width
                        Layout.fillWidth: true
                        PlasmaComponents.Label {
                            id: des
                            text: "Destination"
                            Layout.alignment: Qt.AlignLeft | Qt.AlignHCenter
                        }
                        ComboBox3 {
                            editable: true
                            id: destination
                            Layout.fillWidth: true
                            rightPadding: sw.width
                            Layout.alignment: Qt.AlignLeft | Qt.AlignHCenter
                            model: root.langlist
                            currentIndex: model ? root.destinationIndex : -1
                            onCurrentIndexChanged: root.destinationIndex = destination.currentIndex
                        }
                        PlasmaComponents.ToolButton {
                            id: pinbutton
                            visible: plasmoid.location !== PlasmaCore.Types.Floating
                            flat: true
                            tooltip: "Pin window (CTRL+P)"
                            iconSource: "window-pin"
                            checked: root.pins
                            checkable: true
                            onCheckedChanged: checked ? root.pins = true : root.pins = false
                        }
                    }
                    PlasmaComponents.TextArea {
                        id: rightPanel
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WordWrap
                        readOnly: true
                        text: root.righttext
                        onTextChanged: {
                            root.righttext = rightPanel.text
                        }
                    }

                    RowLayout {
                        width: parent.width
                        Layout.minimumWidth: parent.width
                        PlasmaComponents.ToolButton {
                            Layout.fillWidth: false
                            transformOrigin: Item.Left
                            iconSource: "player-volume"
                            tooltip: "Listen"
                            enabled: rightPanel.text.length > 0 ? true : false
                            onClicked: {
                                listend(root.righttext, "-sp")
                            }
                        }
                        PlasmaComponents.ToolButton {
                            Layout.fillWidth: false
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            iconSource: "edit-copy"
                            enabled: rightPanel.focus
                                     && rightPanel.text.length > 0
                            tooltip: "Copy (Ctrl+C)"
                            onClicked: {

                                copy.trigger()
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }

                        PlasmaComponents.ToolButton {
                            id: transbutton
                            Layout.alignment: Qt.AlignRight
                            flat: true
                            transformOrigin: Item.Right
                            iconSource: "globe"
                            minimumWidth: 1
                            Layout.preferredWidth: this.minimumWidth
                            text: "Translate"
                            tooltip: "Translate (CTRL+Enter)"
                            Layout.fillWidth: false
                            enabled: leftPanel.text.length > 0
                                     && leftPanel.text.length < 5001
                                     && root.sourceIndex !== root.destinationIndex ? true : false
                            onClicked: {
                                trans.trigger()
                            }
                        }
                    }
                }
            }

            Action {
                id: trans
                shortcut: "Ctrl+Return"
                onTriggered: {
                    if (transbutton.enabled === true) {
                        root.righttext = ""
                        root.lefttext = leftPanel.text
                        translate()
                        if (root.cfg_autodetect == true
                                && root.indlang == false) {
                            detectsource()
                        }
                    }
                }
            }
            Action {
                id: clear
                shortcut: "Esc"
                onTriggered: {
                    leftPanel.remove(0, leftPanel.text.length)
                    rightPanel.remove(0, rightPanel.text.length)
                    if (root.cfg_autodetect) {
                        var copy = ["Autodetect"]
                        root.detectlist = copy
                    }
                    leftPanel.focus = true
                }
            }

            Action {
                id: swap
                shortcut: "Ctrl+S"
                onTriggered: {
                    root.swapText = root.lefttext
                    root.lefttext = root.righttext
                    root.righttext = root.swapText
                    root.swapIndex = root.sourceIndex
                    root.sourceIndex = root.destinationIndex
                    root.destinationIndex = root.swapIndex
                    leftPanel.focus = true
                }
            }
            Action {
                id: copy
                shortcut: "Ctrl+C"
                onTriggered: {
                    if (rightPanel.focus == true) {
                        rightPanel.selectAll()
                        rightPanel.copy()
                        rightPanel.deselect()
                    }
                }
            }
            Action {
                id: paste
                shortcut: "Ctrl+V"
                onTriggered: {
                    if (leftPanel.focus == true) {
                        leftPanel.selectAll()
                        leftPanel.paste()
                        leftPanel.deselect()
                    }
                }
            }
            Action {
                id: pinwindow
                shortcut: "Ctrl+P"
                onTriggered: {
                    root.pins = pinbutton.checked ? false : true
                }
            }
        }
        ColumnLayout {
            anchors.centerIn: parent
            visible: root.langlist.length < 2
            PlasmaComponents.Label {
                id: err
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: cfg_autodetect ? "Please make sure that at least one language is selected." : "Please make sure that at least two languages are selected."
                color: "red"
                horizontalAlignment: Text.AlignHCenter
            }
            PlasmaComponents.Button {
                anchors.top: err.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Settings"
                onClicked: plasmoid.action("configure").trigger()
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            visible: root.pack == false
            PlasmaComponents.Label {
                id: install
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Please install translate-shell package and reboot or relog."
                color: "red"
                horizontalAlignment: Text.AlignHCenter
            }
            PlasmaComponents.Button {
                anchors.top: install.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "How to install"
                onClicked: Qt.openUrlExternally(
                               "https://github.com/soimort/translate-shell/wiki/Distros/")
            }
        }
    }

    function loadLangModel() {
        var languages = JSON.parse(cfg_languages)
        var langcopy = []
        var codecopy = []
        for (var i = 0; i < languages.length; i++) {
            if (languages[i].active && languages[i].enabled) {
                langcopy.push(languages[i].lang)
                codecopy.push(languages[i].code)
            }
        }
        root.langlist = langcopy
        root.codelist = codecopy
    }

    function getLocale() {
        //TODO
        var myLocale = Qt.locale().name.split("_")[0]
        var myIndex = root.codelist.indexOf(myLocale)
        root.destinationIndex = myIndex
    }
}
