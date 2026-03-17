import SwiftUI

extension S0 {
    
    public struct Slider: View {
        private let label: String?
        @Binding private var value: Double
        private let range: ClosedRange<Double>
        private let step: Double?
        
        public init(
            _ label: String? = nil,
            value: Binding<Double>,
            in range: ClosedRange<Double> = 0...1,
            step: Double? = nil
        ) {
            self.label = label
            self._value = value
            self.range = range
            self.step = step
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs + S0.Theme.Spacing.xxs) {
                if let label = label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
                
                if let step = step {
                    SwiftUI.Slider(value: $value, in: range, step: step)
                        .tint(S0.Theme.Colors.primary)
                } else {
                    SwiftUI.Slider(value: $value, in: range)
                        .tint(S0.Theme.Colors.primary)
                }
            }
        }
    }
}
