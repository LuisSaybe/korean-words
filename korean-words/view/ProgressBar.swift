
import SwiftUI
import Combine

struct ProgressBar: SwiftUI.View {
    @Binding var value: Double

    var body: some SwiftUI.View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(Color(UIColor.systemBlue))
                .animation(.linear)
                .cornerRadius(45.0)
                .frame(width: CGFloat(self.value) * geometry.size.width)
        }.frame(height: 3)
    }
}
