import SwiftUI
import Combine

struct Router: View {
    @EnvironmentObject var userInterface: UserInterface
    @EnvironmentObject var connection: DatabaseConnection

    var body: some View {
        if let db = self.connection.db, self.userInterface.targetCode != nil {
            EntryView()
        } else {
            HomeView()
        }
    }
}
