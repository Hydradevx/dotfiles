import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import "../../components/controls" as Controls
import "../../globals/state" as GlobalState

GridView {
    id: grid
    cellWidth: 180
    cellHeight: 160
    clip: true
    cacheBuffer: 1000
    
    property string searchTerm: ""
    property int appCount: filteredApplications.count
    property alias model: filteredApplications
    
    signal appLaunched()

    ListModel {
        id: filteredApplications
    }

    function updateFilter() {
        filteredApplications.clear()
        const term = searchTerm.toLowerCase()
        
        for (const app of DesktopEntries.applications.values) {
            if (term === "" || app.name.toLowerCase().includes(term)) {
                filteredApplications.append({ modelData: app })
            }
        }
    }

    delegate: AppCard {
        application: modelData
        onAppLaunched: grid.appLaunched()
    }

    Controls.CustomScrollBar.vertical: Controls.CustomScrollBar {}

    onSearchTermChanged: updateFilter()
    Component.onCompleted: updateFilter()
}