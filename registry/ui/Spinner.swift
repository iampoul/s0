import SwiftUI

extension S0 {
    
    public struct Spinner: View {
        private let lineWidth: CGFloat
        private let size: CGFloat
        @State private var isAnimating = false
        
        public init(size: CGFloat = 20, lineWidth: CGFloat = 2) {
            self.size = size
            self.lineWidth = lineWidth
        }
        
        public var body: some View {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(S0.Theme.Colors.primary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 0.75).repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear { isAnimating = true }
        }
    }
}
