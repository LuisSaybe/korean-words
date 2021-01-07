import Combine
import SQLite

class DatabaseConnection: ObservableObject {
    @Published var db: Connection?

    init(db: Connection?) {
        self.db = db
    }
}
