import SwiftUI

extension S0 {
    
    public struct Skeleton: View {
        private let width: CGFloat?
        private let height: CGFloat
        @State private var isAnimating = false
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        
        public init(width: CGFloat? = nil, height: CGFloat = 20) {
            self.width = width
            self.height = height
        }
        
        public var body: some View {
            RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                .fill(S0.Theme.Colors.muted)
                .frame(width: width, height: height)
                .frame(maxWidth: width == nil ? .infinity : nil)
                .opacity(reduceMotion ? 1.0 : (isAnimating ? 0.5 : 1.0))
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear { isAnimating = !reduceMotion }
                .accessibilityLabel("Loading placeholder")
                .accessibilityHidden(true)
        }
    }
}
