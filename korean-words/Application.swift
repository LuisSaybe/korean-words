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

    func onAppear() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            if !self.userInterface.autoPlay || self.userInterface.targetCode == nil {
                return
            }

            if let db = self.connection.db,
               let targetCode = self.userInterface.targetCode {
                let entries = Table("entry")
                let target_code = Expression<Int>("target_code")
                let word_grade = Expression<String>("word_grade")
                let word_grade_clause = (word_grade == WordGrade.advanced.rawValue && self.userInterface.showAdvancedWords) ||
                    (word_grade == WordGrade.intermediate.rawValue && self.userInterface.showIntermediateWords) ||
                    (word_grade == WordGrade.beginner.rawValue && self.userInterface.showBeginnerWords)
                let nextQuery = entries.select(target_code)
                    .where(
                        target_code > targetCode && word_grade_clause
                    )
                    .order(target_code.asc)
                let firstQuery = entries.select(target_code)
                    .where(
                        word_grade_clause
                    )
                    .order(target_code.asc)

                do {
                    if let row = try db.pluck(nextQuery) {
                        self.userInterface.targetCode = row[target_code]
                    } else if let row = try db.pluck(firstQuery) {
                        self.userInterface.targetCode = row[target_code]
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
                .onAppear(perform: self.onAppear)
                .environmentObject(self.connection)
                .environmentObject(self.userInterface)
        }
    }
}
