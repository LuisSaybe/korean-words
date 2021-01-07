import SwiftUI
import SQLite
import AVFoundation
import Combine

struct EntryView: SwiftUI.View {
    @EnvironmentObject var userInterface: UserInterface
    @EnvironmentObject var db: DatabaseConnection

    func onWordClick() {
        if let targetCode = self.userInterface.targetCode,
           let db = self.db.db,
           let entry = getEntry(db: db, targetCode: targetCode) {
            let utterance = AVSpeechUtterance(string: entry.word)
            let synthesizer = AVSpeechSynthesizer()
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            synthesizer.speak(utterance)
        }
    }

    func onAppear() {
        self.userInterface.$targetCode.sink { debugPrint($0) }
    }

    var body: some SwiftUI.View {
        return (
            VStack {
                VStack(spacing: 40) {
                    if let db = self.db.db,
                       let targetCode = self.userInterface.targetCode,
                       let entry = getEntry(db: db, targetCode: targetCode) {
                        Button(entry.word, action: self.onWordClick)
                            .font(.title)
                        if let code = Locale.current.languageCode {
                            if let sense = getSense(db: db, target_code: targetCode, sense_index: 0),
                               let word = sense.getWord(code: code) {
                                Text(word).font(.title)
                            } else {
                                Text("").font(.title)
                            }
                            if let sense = getSense(db: db, target_code: targetCode, sense_index: 1),
                               let word = sense.getWord(code: code) {
                                Text(word).font(.title)
                            } else {
                                Text("").font(.title)
                            }
                        }
                    } else {
                        Text("Unable to find entry target code of nil")
                    }
                }
                .frame(maxHeight: .infinity)
                .onAppear(perform: self.onAppear)
                BottomControls()
            }.padding()
        )
    }
}
