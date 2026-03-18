import SwiftUI

extension S0 {
    
    public struct Stepper: View {
        private let label: String?
        @Binding private var value: Int
        private let range: ClosedRange<Int>
        
        public init(_ label: String? = nil, value: Binding<Int>, in range: ClosedRange<Int> = 0...100) {
            self.label = label
            self._value = value
            self.range = range
        }
        
        public var body: some View {
            SwiftUI.Stepper(value: $value, in: range) {
                HStack(spacing: S0.Theme.Spacing.sm) {
                    if let label = label {
                        Text(label)
                            .font(S0.Theme.Typography.button)
                            .foregroundColor(S0.Theme.Colors.foreground)
                    }
                    Text("\(value)")
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
            }
            .tint(S0.Theme.Colors.primary)
        }
    }
}
