import SwiftUI
import SQLite

struct HomeView: SwiftUI.View {
    @EnvironmentObject var connection: DatabaseConnection
    @EnvironmentObject var ui: UserInterface
    @EnvironmentObject var userInterface: UserInterface

    func onStart() {
        if let db = self.connection.db {
            let entries = Table("entry")
            let target_code = Expression<Int>("target_code")
            let word_grade = Expression<String>("word_grade")
            let query = entries.select(target_code).where(
                (word_grade == WordGrade.advanced.rawValue && self.userInterface.showAdvancedWords) ||
                (word_grade == WordGrade.intermediate.rawValue && self.userInterface.showIntermediateWords) ||
                (word_grade == WordGrade.beginner.rawValue && self.userInterface.showBeginnerWords)
            )

            do {
                if let entry = try db.pluck(query) {
                    self.ui.targetCode = entry[target_code]
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

