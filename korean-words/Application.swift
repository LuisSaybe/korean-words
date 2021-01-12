import SwiftUI
import SQLite

@main
struct Application: App {
    var connection: DatabaseConnection
    var userInterface: UserInterface = UserInterface()

    init() {
        if let path = Bundle.main.path(forResource: "entries-with-word-grades", ofType: "db") {
            do {
                let db = try Connection(path, readonly: true)
                self.connection = DatabaseConnection(db: db)
            } catch {
                self.connection = DatabaseConnection(db: nil)
            }
        } else {
            print("unable to find database file")
            self.connection = DatabaseConnection(db: nil)
        }
    }

    var body: some Scene {
        WindowGroup {
            Router()
                .environmentObject(self.connection)
                .environmentObject(self.userInterface)
        }
    }
}
