import SwiftUI
import SQLite
import AVFoundation

struct BottomControls: SwiftUI.View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    
    func onAutoPlayClick() {
        self.store.send(.setAutoplay(data: !self.store.state.autoPlay))
    }
    
    var body: some SwiftUI.View {
        return (
            HStack {
                Button(self.store.state.autoPlay ? "Autoplay Off" : "Autoplay On", action: self.onAutoPlayClick)
            }
        )
    }
}

