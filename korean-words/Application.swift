import SwiftUI
import SQLite

@main
struct Application: App {
    let store = ApplicationStore<ApplicationState, ApplicationAction>(initialState: ApplicationState(
        autoPlay: false
    ), reducer: applicationReducer)

    init() {
        do {
            let path = Bundle.main.path(forResource: "database", ofType: "db")!
            let db = try Connection(path, readonly: true)
            self.store.send(.setDatabaseConnection(data: db))
        } catch {
            print("unable to connect")
        }
    }

    func onAppear() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if !self.store.state.autoPlay || self.store.state.targetCode == nil {
                return
            }

            if let db = self.store.state.db,
               let targetCode = self.store.state.targetCode {
                let entries = Table("entry")
                let target_code = Expression<Int>("target_code")
                let nextQuery = entries.select(target_code)
                    .where(target_code > targetCode)
                    .order(target_code.asc)
                let firstQuery = entries.select(target_code)
                    .order(target_code.asc)

                do {
                    if let row = try db.pluck(nextQuery) {
                        self.store.send(.setCurrentTargetCode(data: row[target_code]))
                    } else if let row = try db.pluck(firstQuery) {
                        self.store.send(.setCurrentTargetCode(data: row[target_code]))
                    }
                } catch {
                    print("Unable to get next word in Timer!")
                }
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            Router()
                .environmentObject(self.store)
                .onAppear(perform: self.onAppear)
        }
    }
}
