import SwiftUI

extension S0 {
    
    public struct Select<Value: Hashable>: View {
        private let label: String?
        private let options: [(value: Value, label: String)]
        @Binding private var selection: Value
        
        public init(_ label: String? = nil, selection: Binding<Value>, options: [(value: Value, label: String)]) {
            self.label = label
            self._selection = selection
            self.options = options
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs + S0.Theme.Spacing.xxs) {
                if let label = label {
                    Text(label)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
                
                Picker("", selection: $selection) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(options[index].label).tag(options[index].value)
                    }
                }
                #if os(iOS)
                .pickerStyle(.menu)
                #else
                .pickerStyle(.automatic)
                #endif
                .accessibilityLabel(label ?? "Selection")
                .tint(S0.Theme.Colors.foreground)
                .padding(.horizontal, S0.Theme.Spacing.md)
                .padding(.vertical, S0.Theme.Spacing.xs)
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
