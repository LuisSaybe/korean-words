import Combine
import SQLite
import AVFoundation

enum DisplayLangauge : String {
    case en = "en"
    case ja = "ja"
    case fr = "fr"
    case es = "es"
    case ar = "ar"
    case mn = "mn"
    case vi = "vi"
    case th = "th"
    case id = "id"
    case ru = "ru"

    static func getDefaultDisplayLanguage() -> DisplayLangauge {
        if let code = Locale.current.languageCode {
            if code == "en" {
                return .en
            }

            if code == "ja" {
                return .ja
            }

            if code == "fr" {
                return .fr
            }

            if code == "es" {
                return .es
            }

            if code == "ar" {
                return .ar
            }

            if code == "mn" {
                return .mn
            }

            if code == "vi" {
                return .vi
            }

            if code == "th" {
                return .th
            }

            if code == "id" {
                return .id
            }

            if code == "ru" {
                return .ru
            }
        }

        return DisplayLangauge.en
    }
}

enum AutoPlayDuration: Int {
  case slow = 8
  case medium = 4
  case fast = 2
}

enum RouteName {
    case word
    case settings
}

class UserInterface: ObservableObject {
    @Published var autoPlay: Bool = false
    @Published var displayLanguage: DisplayLangauge = DisplayLangauge.getDefaultDisplayLanguage()
    @Published var autoPlayDuration: AutoPlayDuration = .medium
    @Published var playEntryOnTransition: Bool = false
    @Published var showAdvancedWords: Bool = false
    @Published var showIntermediateWords: Bool = false
    @Published var showBeginnerWords: Bool = true
    @Published var alwaysShowDefinition: Bool = true
    @Published var view = RouteName.word
    @Published var targetCodes: [Int] = []
    @Published var targetCodeIndex: Int = 0
    @Published var shuffle: Bool = false
    @Published var lastShuffleTime: Date = Date()
}
