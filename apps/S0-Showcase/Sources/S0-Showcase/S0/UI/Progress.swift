import SwiftUI

extension S0 {
    
    public struct Progress: View {
        private let value: Double
        
        /// Creates a progress bar.
        /// - Parameter value: Progress from 0.0 to 1.0
        public init(value: Double) {
            self.value = min(max(value, 0), 1)
        }
        
        public var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.full)
                        .fill(S0.Theme.Colors.muted)
                        .frame(height: S0.Theme.Spacing.sm)
                    
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.full)
                        .fill(S0.Theme.Colors.primary)
                        .frame(width: geometry.size.width * value, height: S0.Theme.Spacing.sm)
                        .animation(S0.Theme.Animation.default, value: value)
                }
            }
            .frame(height: S0.Theme.Spacing.sm)
        }
    }
}
