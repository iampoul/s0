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
            VStack(alignment: .leading, spacing: 6) {
                if let label = label {
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .padding(.horizontal, 12)
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
