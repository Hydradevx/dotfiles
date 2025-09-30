import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import Quickshell 
import Quickshell.Hyprland 
import "../../components/controls" as Controls
import "../../globals/state" as GlobalState

GridView {
    id: grid
    cellWidth: 180
    cellHeight: 160
    clip: true
    cacheBuffer: 1000
    
    property string searchTerm: ""
    property int appCount: count
    property ListModel appModel: ListModel {}
    
    signal appLaunched()

    property var allApplications: DesktopEntries.applications.values || []
    
    delegate: AppCard {
        application: modelData
        onAppLaunched: {
            grid.appLaunched()
        }
    }

    Controls.CustomScrollBar.vertical: Controls.CustomScrollBar {}

    function updateFilter() {
        appModel.clear()
        const term = searchTerm.toLowerCase()
        
        console.log("Filtering applications, total:", allApplications.length, "search term:", term)
        
        for (const app of allApplications) {
            if (!app || !app.name) continue
            
            if (term === "" || app.name.toLowerCase().includes(term)) {
                appModel.append({ modelData: app })
            }
        }
        
        console.log("Filtered to:", appModel.count, "applications")
    }

    Component.onCompleted: {
        console.log("AppGrid initialized, total apps:", allApplications.length)
        updateFilter()
    }

    onSearchTermChanged: updateFilter()

    model: appModel
}