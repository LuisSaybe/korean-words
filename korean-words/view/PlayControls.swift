
import SwiftUI
import Combine

struct PlayControls: SwiftUI.View {
    let playHeight: CGFloat = 40
    let playWidth: CGFloat = 40
    let nextPreviousHeight: CGFloat = 40
    @EnvironmentObject var userInterface: UserInterface

    func onPlayToggle() {
        self.userInterface.autoPlay = !self.userInterface.autoPlay
    }

    func onPreviousClick() {
        if self.userInterface.targetCodeIndex <= 0 {
            self.userInterface.targetCodeIndex = self.userInterface.targetCodes.count - 1
        } else {
            self.userInterface.targetCodeIndex -= 1
        }
    }
    
    func onNextClick() {
        if self.userInterface.targetCodeIndex >= self.userInterface.targetCodes.count - 1 {
            self.userInterface.targetCodeIndex = 0
        } else {
            self.userInterface.targetCodeIndex += 1
        }
    }

    var body: some SwiftUI.View {
        HStack(alignment: .center, spacing: 60) {
            Button(action: self.onPreviousClick) {
                Image("previous")
                    .resizable()
                    .scaledToFit()
                    .frame(height: self.nextPreviousHeight)
            }.buttonStyle(PlainButtonStyle())
            Button(action: self.onPlayToggle) {
                if self.userInterface.autoPlay {
                    Image("pause")
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.playWidth, height: self.playHeight)
                } else {
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.playWidth, height: self.playHeight)
                }
            }.buttonStyle(PlainButtonStyle())
            Button(action: self.onNextClick) {
                Image("next")
                    .resizable()
                    .scaledToFit()
                    .frame(height: self.nextPreviousHeight)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

