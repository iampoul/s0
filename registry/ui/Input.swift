import SwiftUI

extension S0 {
    public struct Input: View {
        private let label: String?
        private let placeholder: String
        @Binding private var text: String
        
        public init(_ label: String? = nil, text: Binding<String>, placeholder: String = "") {
            self.label = label
            self._text = text
            self.placeholder = placeholder
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs + S0.Theme.Spacing.xxs) {
                if let label = label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
                
                TextField(placeholder, text: $text)
                    .font(S0.Theme.Typography.button)
                    .accessibilityLabel(label ?? placeholder)
                    .padding(.horizontal, S0.Theme.Spacing.md)
                    .padding(.vertical, 10)
                    .background(S0.Theme.Colors.background)
                    .cornerRadius(S0.Theme.radius)
                    .overlay(
                        RoundedRectangle(cornerRadius: S0.Theme.radius)
                            .stroke(S0.Theme.Colors.border, lineWidth: 1)
                    )
            }
        }
    }
}
