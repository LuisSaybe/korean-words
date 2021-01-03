import SwiftUI
import SQLite

struct HomeView: SwiftUI.View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    func onStart() {
        if let db = self.store.state.db {
            let entries = Table("entry")
            let target_code = Expression<Int>("target_code")
            let query = entries.select(target_code)

            do {
                if let entry = try db.pluck(query) {
                    self.store.send(.setCurrentTargetCode(data: entry[target_code]))
                }
            } catch {
                print("Unable to retrieve first target code")
            }
        }
    }

    var body: some SwiftUI.View {
        Button("Let's study!", action: self.onStart)
    }
}

