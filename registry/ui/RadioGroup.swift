import SwiftUI

extension S0 {
    
    public struct RadioGroup<Value: Hashable>: View {
        private let options: [(value: Value, label: String)]
        @Binding private var selection: Value
        
        public init(selection: Binding<Value>, options: [(value: Value, label: String)]) {
            self._selection = selection
            self.options = options
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.md) {
                ForEach(0..<options.count, id: \.self) { index in
                    let option = options[index]
                    SwiftUI.Button {
                        selection = option.value
                    } label: {
                        HStack(spacing: S0.Theme.Spacing.sm) {
                            Circle()
                                .stroke(selection == option.value ? S0.Theme.Colors.primary : S0.Theme.Colors.border, lineWidth: 1.5)
                                .frame(width: 18, height: 18)
                                .overlay(
                                    Circle()
                                        .fill(S0.Theme.Colors.primary)
                                        .frame(width: 10, height: 10)
                                        .opacity(selection == option.value ? 1 : 0)
                                )
                                .animation(S0.Theme.Animation.fast, value: selection)
                            
                            Text(option.label)
                                .font(S0.Theme.Typography.button)
                                .foregroundColor(S0.Theme.Colors.foreground)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
