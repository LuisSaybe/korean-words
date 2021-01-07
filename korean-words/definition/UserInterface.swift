import Combine
import SQLite

class UserInterface: ObservableObject {
    @Published var targetCode: Int? = nil
    @Published var autoPlay: Bool = false
    @Published var showAdvancedWords: Bool = false
    @Published var showIntermediateWords: Bool = false
    @Published var showBeginnerWords: Bool = true
}
