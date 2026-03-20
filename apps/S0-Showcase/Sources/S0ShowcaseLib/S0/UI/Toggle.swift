import SwiftUI

extension S0 {
    
    public struct Toggle: View {
        private let label: String?
        @Binding private var isOn: Bool
        
        public init(_ label: String? = nil, isOn: Binding<Bool>) {
            self.label = label
            self._isOn = isOn
        }
        
        public var body: some View {
            SwiftUI.Toggle(isOn: $isOn) {
                if let label = label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.foreground)
                }
            }
            .tint(S0.Theme.Colors.primary)
            .accessibilityLabel(label ?? "Toggle")
        }
    }
}
