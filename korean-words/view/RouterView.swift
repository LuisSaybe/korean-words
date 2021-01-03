import SwiftUI

struct Router: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    
    var body: some View {
        if let targetCode = self.store.state.targetCode {
            EntryView(targetCode: targetCode)
        } else {
           HomeView()
        }
    }
}
