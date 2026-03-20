import SwiftUI

extension S0 {
    
    public struct TextArea: View {
        private let label: String?
        private let placeholder: String
        @Binding private var text: String
        private let minHeight: CGFloat
        
        public init(
            _ label: String? = nil,
            text: Binding<String>,
            placeholder: String = "",
            minHeight: CGFloat = 80
        ) {
            self.label = label
            self._text = text
            self.placeholder = placeholder
            self.minHeight = minHeight
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs + S0.Theme.Spacing.xxs) {
                if let label = label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(S0.Theme.Typography.button)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                            .padding(.horizontal, S0.Theme.Spacing.md)
                            .padding(.vertical, S0.Theme.Spacing.md)
                    }
                    
                    TextEditor(text: $text)
                        .font(S0.Theme.Typography.button)
                        .scrollContentBackground(.hidden)
                        .accessibilityLabel(label ?? placeholder)
                        .padding(.horizontal, S0.Theme.Spacing.sm)
                        .padding(.vertical, S0.Theme.Spacing.sm)
                        .frame(minHeight: minHeight)
                }
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
