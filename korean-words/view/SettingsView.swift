import SwiftUI
import Combine

struct SettingsView: SwiftUI.View {
    @EnvironmentObject var ui: UserInterface
    @EnvironmentObject var db: DatabaseConnection
    @State var displayLanguageIndex: Int = -1
    @State var autoPlayDurationIndex: Int = -1
    let labelFont: Font = .system(size: 18, weight: .bold, design: .default)
    let displayLanguageOptions: [(label: String, key: DisplayLangauge)] = [
        ("English", .en),
        ("日本語", .ja),
        ("Français", .fr),
        ("Español", .es),
        ("Arabic", .ar),
        ("монгол хэл", .mn),
        ("Tiếng Việt", .vi),
        ("ภาษาไทย", .th),
        ("Bahasa Indonesia", .id),
        ("русский язык", .ru)
    ]
    let playSpeedOptions: [(label: String, key: AutoPlayDuration)] = [
        ("Slow", .slow),
        ("Medium", .medium),
        ("Fast", .fast)
    ]
    
    func onDisplayLanguage(displayLanguage: DisplayLangauge) {
        if let index = self.displayLanguageOptions.map({ $0.key }).firstIndex(of: displayLanguage) {
            self.displayLanguageIndex = index
        }
    }

    func onDisplayLanguageSelectionChosen(index: Int) {
        if index > -1 {
            let nextKey = self.displayLanguageOptions[index].key

            if self.ui.displayLanguage.rawValue != nextKey.rawValue {
                self.ui.displayLanguage = nextKey
            }
        }
    }
    
    func onPlaySpeed(duration: AutoPlayDuration) {
        if let index = self.playSpeedOptions.map({ $0.key }).firstIndex(of: duration) {
            self.autoPlayDurationIndex = index
        }
    }

    func onPlaySpeedSelectionChosen(index: Int) {
        if index > -1 {
            let nextKey = self.playSpeedOptions[index].key

            if self.ui.autoPlayDuration.rawValue != nextKey.rawValue {
                self.ui.autoPlayDuration = nextKey
            }
        }
    }

    var body: some SwiftUI.View {
        return (
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: { self.ui.view = .word }) {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                    }.buttonStyle(PlainButtonStyle())
                    VStack(spacing: 22) {
                        Toggle("Show beginner words", isOn: self.$ui.showBeginnerWords).font(labelFont)
                        Toggle("Show intermediate words", isOn: self.$ui.showIntermediateWords).font(labelFont)
                        Toggle("Show advanced words", isOn: self.$ui.showAdvancedWords).font(labelFont)
                        Toggle("Listen to word on transition", isOn: self.$ui.playEntryOnTransition).font(labelFont)
                        Toggle("Always show definition", isOn: self.$ui.alwaysShowDefinition).font(labelFont)
                        Toggle("Shuffle", isOn: self.$ui.shuffle).font(labelFont)
                        if self.autoPlayDurationIndex > -1 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Play speed").font(labelFont)
                                Picker(selection: self.$autoPlayDurationIndex, label: Text("Play speed")) {
                                    ForEach(0 ..< self.playSpeedOptions.count) {
                                        Text(self.playSpeedOptions[$0].label)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                            }
                        }
                        if self.displayLanguageIndex > -1 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Language").font(labelFont)
                                Picker(selection: self.$displayLanguageIndex, label: Text("Language")) {
                                    ForEach(0 ..< self.displayLanguageOptions.count) {
                                        Text(self.displayLanguageOptions[$0].label)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                            }
                        }
                    }.padding(.top, 40).frame(maxHeight: .infinity)
                }.padding()
            }
            .onReceive(self.ui.$displayLanguage, perform: self.onDisplayLanguage)
            .onReceive(Just(self.displayLanguageIndex), perform: self.onDisplayLanguageSelectionChosen)
            .onReceive(self.ui.$autoPlayDuration, perform: self.onPlaySpeed)
            .onReceive(Just(self.autoPlayDurationIndex), perform: self.onPlaySpeedSelectionChosen)
        )
    }
}
