import SwiftUI

struct BottomControls: SwiftUI.View {
    @EnvironmentObject var userInterface: UserInterface

    func onAutoPlayClick() {
        self.userInterface.autoPlay = !self.userInterface.autoPlay
    }
    
    var body: some SwiftUI.View {
        return (
            HStack {
                Button(self.userInterface.autoPlay ? "Autoplay Off" : "Autoplay On", action: self.onAutoPlayClick)
            }
        )
    }
}

