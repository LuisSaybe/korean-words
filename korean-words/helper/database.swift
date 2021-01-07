import SQLite

func getEntry(db: Connection, targetCode: Int) -> Entry? {
    let entries = Table("entry")
    let target_code = Expression<Int>("target_code")
    let query = entries.select(entries[*])
        .where(target_code == targetCode)

    do {
        if let row = try db.pluck(query) {
            return Entry(row: row)
        }
    } catch {
       return nil
    }

    return nil
}

func getSense(db: Connection, target_code: Int, sense_index: Int) -> SenseInfo? {
    let entries = Table("sense_info")
    let targetCode = Expression<Int>("target_code")
    let senseIndex = Expression<Int>("sense_index")
    let query = entries.select(entries[*])
        .where(target_code == targetCode && senseIndex == sense_index)

    do {
        if let row = try db.pluck(query) {
            return SenseInfo(row: row)
        }
    } catch {
       return nil
    }

    return nil
}
