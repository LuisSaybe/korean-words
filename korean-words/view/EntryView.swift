import SwiftUI
import SQLite
import AVFoundation
import Combine

struct EntryView: SwiftUI.View {
    @EnvironmentObject var ui: UserInterface
    @EnvironmentObject var db: DatabaseConnection
    @State var showDefinition: Bool = false
    @State var progressTimer: Timer?
    @State var progressValue: Double = 1

    func onDisappear() {
        self.progressTimer?.invalidate()
    }

    func speakWord(targetCodeIndex: Int) {
        if let entry = self.getCurrentEntry(targetCodeIndex: targetCodeIndex) {
            let utterance = AVSpeechUtterance(string: entry.entry.word)
            let synthesizer = AVSpeechSynthesizer()
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            synthesizer.speak(utterance)
        }
    }

    func onTargetCodeIndex(index: Int) {
        self.showDefinition = self.ui.alwaysShowDefinition
        
        if (self.ui.playEntryOnTransition) {
            speakWord(targetCodeIndex: index)
        }

        if (self.ui.autoPlay) {
            self.initializeTimer()
        }
    }

    func initializeTimer() {
        let interval = 0.1
        self.progressValue = 0
        self.progressTimer?.invalidate()

        self.progressTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            self.progressValue = min(self.progressValue + interval / Double(self.ui.autoPlayDuration.rawValue), 1)

            if self.progressValue >= 1 {
                self.ui.targetCodeIndex = self.ui.targetCodeIndex + 1 < self.ui.targetCodes.count ? self.ui.targetCodeIndex + 1 : 0
            }
        }
    }

    func onAutoPlay(autoPlay: Bool) {
        if (autoPlay) {
            self.initializeTimer()
        } else {
            self.progressTimer?.invalidate()
            self.progressValue = 0
        }
    }

    func onShowDefinition() {
        self.showDefinition = true
    }

    func getTargetCode(targetCodeIndex: Int) -> Int? {
        if targetCodeIndex < self.ui.targetCodes.count {
            return self.ui.targetCodes[targetCodeIndex]
        }
        
        return nil
    }

    func getCurrentEntry(targetCodeIndex: Int) -> FullEntry? {
        if let db = self.db.db,
           let targetCode = self.getTargetCode(targetCodeIndex: targetCodeIndex) {
            return getFullEntry(db: db, targetCode: targetCode)
        }

        return nil
    }

    var body: some SwiftUI.View {
        return (
            VStack {
                ProgressBar(value: self.$progressValue)
                HStack {
                    if self.ui.targetCodes.count > 0 {
                        Text("\(self.ui.targetCodeIndex + 1) / \(self.ui.targetCodes.count)")
                    }
                    Spacer()
                    Button(action: { self.ui.view = .settings }) {
                        Image("settings")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                    }.buttonStyle(PlainButtonStyle())
                }
                if let info = self.getCurrentEntry(targetCodeIndex: self.ui.targetCodeIndex) {
                    VStack(spacing: 40) {
                        Button(info.entry.word, action: { self.speakWord(targetCodeIndex: self.ui.targetCodeIndex) })
                            .font(.title)

                        let senses = info.senses.count > 2 ? Array(info.senses[0 ..< 2]) : info.senses

                        if self.showDefinition {
                            ForEach(senses, id: \.sense_index) { sense in
                                if let word = sense.getWord(code: self.ui.displayLanguage.rawValue) {
                                    Text(word).font(.title)
                                }
                            }
                        } else {
                            Button("Show definition", action: self.onShowDefinition)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    PlayControls()
                } else {
                    VStack {
                        Text("No words to show")
                    }.frame(maxHeight: .infinity)
                }
            }
            .padding()
            .onReceive(self.ui.$targetCodeIndex, perform: self.onTargetCodeIndex)
            .onReceive(self.ui.$autoPlay, perform: self.onAutoPlay)
            .onDisappear(perform: self.onDisappear)
        )
    }
}
