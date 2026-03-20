import SwiftUI

// MARK: - S0 SegmentedControl

extension S0 {
    public struct SegmentedControl<Value: Hashable>: View {
        @Binding private var selection: Value
        private let options: [(value: Value, label: String)]
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        public init(
            selection: Binding<Value>,
            options: [(value: Value, label: String)]
        ) {
            self._selection = selection
            self.options = options
        }

        public var body: some View {
            HStack(spacing: S0.Theme.Spacing.xxs) {
                ForEach(options.indices, id: \.self) { index in
                    let option = options[index]
                    let isSelected = selection == option.value

                    Button {
                        withAnimation(reduceMotion ? nil : S0.Theme.Animation.fast) {
                            selection = option.value
                        }
                    } label: {
                        Text(option.label)
                            .font(S0.Theme.Typography.subheadline)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .foregroundColor(
                                isSelected
                                    ? S0.Theme.Colors.foreground
                                    : S0.Theme.Colors.mutedForeground
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, S0.Theme.Spacing.sm)
                            .background(
                                isSelected
                                    ? S0.Theme.Colors.background
                                    : Color.clear
                            )
                            .cornerRadius(S0.Theme.Radius.sm)
                            .s0Shadow(.sm)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(option.label)
                    .accessibilityValue(isSelected ? "Selected" : "Not selected")
                }
            }
            .padding(S0.Theme.Spacing.xxs)
            .background(S0.Theme.Colors.muted)
            .cornerRadius(S0.Theme.Radius.md)
        }
    }
}
