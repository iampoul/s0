import SwiftUI

extension S0 {
    
    public struct Checkbox: View {
        private let label: String?
        @Binding private var isChecked: Bool
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        
        public init(_ label: String? = nil, isChecked: Binding<Bool>) {
            self.label = label
            self._isChecked = isChecked
        }
        
        public var body: some View {
            SwiftUI.Button {
                isChecked.toggle()
            } label: {
                HStack(spacing: S0.Theme.Spacing.sm) {
                    ZStack {
                        RoundedRectangle(cornerRadius: S0.Theme.Radius.sm)
                            .stroke(isChecked ? Color.clear : S0.Theme.Colors.border, lineWidth: 1.5)
                            .frame(width: 18, height: 18)
                        
                        if isChecked {
                            RoundedRectangle(cornerRadius: S0.Theme.Radius.sm)
                                .fill(S0.Theme.Colors.primary)
                                .frame(width: 18, height: 18)
                            
                            Image(systemName: "checkmark")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(S0.Theme.Colors.primaryForeground)
                        }
                    }
                    .animation(reduceMotion ? nil : S0.Theme.Animation.fast, value: isChecked)
                    
                    if let label = label {
                        Text(label)
                            .font(S0.Theme.Typography.button)
                            .foregroundColor(S0.Theme.Colors.foreground)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(label ?? "Checkbox")
            .accessibilityValue(isChecked ? "Checked" : "Unchecked")
            .accessibilityAddTraits(.isButton)
        }
    }
}
