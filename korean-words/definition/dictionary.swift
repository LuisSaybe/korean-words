import SQLite

enum WordGrade: String {
  case none = "없음"
  case beginner = "초급"
  case intermediate = "중급"
  case advanced = "고급"
}

struct FullEntry {
    let entry: Entry
    let senses: [SenseInfo]
}

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

struct SenseInfo {
    let target_code: Int
    let sense_index: Int
    let definition: String
    let english: String?
    let english_dfn: String?
    let japanese: String?
    let japanese_dfn: String?
    let french: String?
    let french_dfn: String?
    let spanish: String?
    let spanish_dfn: String?
    let arabic: String?
    let arabic_dfn: String?
    let mongolian: String?
    let mongolian_dfn: String?
    let vietnamese: String?
    let vietnamese_dfn: String?
    let thai: String?
    let thai_dfn: String?
    let indonesian: String?
    let indonesian_dfn: String?
    let russian: String?
    let russian_dfn: String?

    init(row: Row) {        
        self.target_code = row[Expression<Int>("target_code")]
        self.sense_index = row[Expression<Int>("sense_index")]
        self.definition = row[Expression<String>("definition")]
        self.english = row[Expression<String?>("english")]
        self.english_dfn = row[Expression<String?>("english_dfn")]
        self.japanese = row[Expression<String?>("japanese")]
        self.japanese_dfn = row[Expression<String?>("japanese_dfn")]
        self.french = row[Expression<String?>("french")]
        self.french_dfn = row[Expression<String?>("french_dfn")]
        self.spanish = row[Expression<String?>("spanish")]
        self.spanish_dfn = row[Expression<String?>("spanish_dfn")]
        self.arabic = row[Expression<String?>("arabic")]
        self.arabic_dfn = row[Expression<String?>("arabic_dfn")]
        self.mongolian = row[Expression<String?>("mongolian")]
        self.mongolian_dfn = row[Expression<String?>("mongolian_dfn")]
        self.thai = row[Expression<String?>("thai")]
        self.thai_dfn = row[Expression<String?>("thai_dfn")]
        self.indonesian = row[Expression<String?>("indonesian")]
        self.indonesian_dfn = row[Expression<String?>("indonesian_dfn")]
        self.russian = row[Expression<String?>("russian")]
        self.russian_dfn = row[Expression<String?>("russian_dfn")]
        self.vietnamese = row[Expression<String?>("vietnamese")]
        self.vietnamese_dfn = row[Expression<String?>("vietnamese_dfn")]
    }

    func getWord(code: String) -> String? {
        if code == "en" {
            return self.english
        }
        
        if code == "ja" {
            return self.japanese
        }
        
        if code == "fr" {
            return self.french
        }
        
        if code == "es" {
            return self.spanish
        }
        
        if code == "ar" {
            return self.arabic
        }
        
        if code == "mn" {
            return self.mongolian
        }
        
        if code == "vi" {
            return self.vietnamese
        }
        
        if code == "th" {
            return self.thai
        }
        
        if code == "id" {
            return self.indonesian
        }

        if code == "ru" {
            return self.russian
        }

        return nil
    }

    func deviceLanguageToSenseLanguageDfnColumn(code: String) -> String? {
        if code == "en" {
            return self.english_dfn
        }
        
        if code == "ja" {
            return self.japanese_dfn
        }
        
        if code == "fr" {
            return self.french_dfn
        }
        
        if code == "es" {
            return self.spanish_dfn
        }
        
        if code == "ar" {
            return self.arabic_dfn
        }
        
        if code == "mn" {
            return self.mongolian_dfn
        }
        
        if code == "vi" {
            return self.vietnamese_dfn
        }
        
        if code == "th" {
            return self.thai_dfn
        }
        
        if code == "id" {
            return self.indonesian_dfn
        }
        
        if code == "ru" {
            return self.russian_dfn
        }

        return self.english_dfn
    }
}
