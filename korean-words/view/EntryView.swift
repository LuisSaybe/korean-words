import SwiftUI
import SQLite
import AVFoundation

struct EntryView: SwiftUI.View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let targetCode: Int

    init(targetCode: Int) {
        self.targetCode = targetCode
    }

    func getEntry() -> Entry? {
        if let db = self.store.state.db {
            let entries = Table("entry")
            let target_code = Expression<Int>("target_code")
            let query = entries.select(entries[*])
                .where(target_code == self.targetCode)

            do {
                if let row = try db.pluck(query) {
                    return Entry(row: row)
                }
            } catch {
               return nil
            }
        }

        return nil
    }

    func onWordClick() {
        guard let entry = self.getEntry() else {
            return
        }

        let utterance = AVSpeechUtterance(string: entry.word)
        let synthesizer = AVSpeechSynthesizer()
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        synthesizer.speak(utterance)
    }

    var body: some SwiftUI.View {
        return (
            VStack {
                VStack {
                    if let entry = self.getEntry() {
                        Button(entry.word, action: self.onWordClick)
                    } else {
                        Text("Unable to find entry \(self.targetCode)")
                    }
                }.frame(maxHeight: .infinity)
                BottomControls()
            }.padding()
        )
    }
}
