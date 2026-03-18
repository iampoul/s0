import SwiftUI

extension S0 {
    
    public struct Skeleton: View {
        private let width: CGFloat?
        private let height: CGFloat
        @State private var isAnimating = false
        
        public init(width: CGFloat? = nil, height: CGFloat = 20) {
            self.width = width
            self.height = height
        }
        
        public var body: some View {
            RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                .fill(S0.Theme.Colors.muted)
                .frame(width: width, height: height)
                .frame(maxWidth: width == nil ? .infinity : nil)
                .opacity(isAnimating ? 0.5 : 1.0)
                .animation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear { isAnimating = true }
        }
    }
}
