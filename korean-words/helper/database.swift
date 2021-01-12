import SQLite

func getTargetCodes(db: Connection, ui: UserInterface) -> [Int]? {
    let entries = Table("entry")
    let target_code = Expression<Int>("target_code")
    let word_grade = Expression<String>("word_grade")
    let word_grade_clause = (word_grade == WordGrade.advanced.rawValue && ui.showAdvancedWords) ||
        (word_grade == WordGrade.intermediate.rawValue && ui.showIntermediateWords) ||
        (word_grade == WordGrade.beginner.rawValue && ui.showBeginnerWords)
    let query = entries.select(target_code)
        .where(word_grade_clause)
        .order(target_code.asc)

    let sequence: AnySequence<Row>
    
    do  {
        sequence = try db.prepare(query)
    } catch {
        return nil
    }

    return sequence.map { $0[target_code] }
}

func getFullEntry(db: Connection, targetCode: Int) -> FullEntry? {
    if let entry = getEntry(db: db, targetCode: targetCode) {
        let senses = getSenses(db: db, targetCode: targetCode) ?? []
        
        return FullEntry(
            entry: entry,
            senses: senses
        )
    }
    
    return nil
}

func getSenses(db: Connection, targetCode: Int) -> [SenseInfo]? {
    let table = Table("sense_info")
    let query = table.select(table[*])
        .where(targetCode == Expression<Int>("target_code"))

    do {
        let rows = try db.prepare(query)
        return rows.map { SenseInfo(row: $0) }
    } catch {
       return nil
    }
}

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
