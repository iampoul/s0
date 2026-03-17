import SwiftUI

extension S0 {
    
    public struct Label: View {
        private let text: String
        private let isRequired: Bool
        
        public init(_ text: String, required: Bool = false) {
            self.text = text
            self.isRequired = required
        }
        
        public var body: some View {
            HStack(spacing: S0.Theme.Spacing.xxs) {
                Text(text)
                    .font(S0.Theme.Typography.button)
                    .foregroundColor(S0.Theme.Colors.foreground)
                
                if isRequired {
                    Text("*")
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.destructive)
                }
            }
        }
    }
}
