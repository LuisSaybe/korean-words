import SQLite

struct Entry {
    let targetCode: Int
    let word: String

    init(row: Row) {
        let target_code = Expression<Int>("target_code")
        let word = Expression<String>("word")

        self.targetCode = row[target_code]
        self.word = row[word]
    }
}
