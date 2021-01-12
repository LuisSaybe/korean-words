import SwiftUI
import Combine

struct Router: View {
    @EnvironmentObject var ui: UserInterface
    @EnvironmentObject var connection: DatabaseConnection

    func onWordsQueryUpdated(value: Bool) {
        if let db = self.connection.db {
            if let codes = getTargetCodes(db: db, ui: self.ui) {
                self.ui.targetCodes = codes
                self.ui.targetCodeIndex = 0
            }
        }
    }

    func onShuffle(shuffle: Bool) {
        self.ui.targetCodes = self.ui.targetCodes.shuffled()
    }

    var body: some View {
        VStack {
            if self.ui.view == RouteName.settings {
                SettingsView()
            } else if self.ui.view == RouteName.word {
                EntryView()
            }
        }.onReceive(self.ui.$showBeginnerWords, perform: self.onWordsQueryUpdated)
            .onReceive(self.ui.$showIntermediateWords, perform: self.onWordsQueryUpdated)
            .onReceive(self.ui.$showAdvancedWords, perform: self.onWordsQueryUpdated)
            .onReceive(self.ui.$shuffle, perform: self.onShuffle)
    }
}
