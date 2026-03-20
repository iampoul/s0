import SwiftUI

// MARK: - S0 DatePicker

extension S0 {
    public enum DatePickerVariant {
        case `default`
        case compact
    }

    public struct DatePicker: View {
        @Binding private var selection: Date
        private let label: String?
        private let variant: DatePickerVariant
        private let displayedComponents: SwiftUI.DatePicker.Components

        public init(
            _ label: String? = nil,
            selection: Binding<Date>,
            variant: DatePickerVariant = .default,
            displayedComponents: SwiftUI.DatePicker.Components = [.date]
        ) {
            self.label = label
            self._selection = selection
            self.variant = variant
            self.displayedComponents = displayedComponents
        }

        public var body: some View {
            Group {
                switch variant {
                case .default:
                    defaultVariant
                case .compact:
                    compactVariant
                }
            }
        }

        private var defaultVariant: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                if let label {
                    Text(label)
                        .font(S0.Theme.Typography.subheadline)
                        .foregroundColor(S0.Theme.Colors.foreground)
                }

                SwiftUI.DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: displayedComponents
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .accessibilityLabel(label ?? "Date picker")
                .padding(S0.Theme.Spacing.md)
                .background(S0.Theme.Colors.background)
                .cornerRadius(S0.Theme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                        .stroke(S0.Theme.Colors.border, lineWidth: 1)
                )
            }
        }

        private var compactVariant: some View {
            HStack {
                if let label {
                    Text(label)
                        .font(S0.Theme.Typography.body)
                        .foregroundColor(S0.Theme.Colors.foreground)
                }

                Spacer()

                SwiftUI.DatePicker(
                    "",
                    selection: $selection,
                    displayedComponents: displayedComponents
                )
                .labelsHidden()
                #if os(iOS)
                .datePickerStyle(.compact)
                #else
                .datePickerStyle(.field)
                #endif
                .accessibilityLabel(label ?? "Date picker")
            }
            .padding(.horizontal, S0.Theme.Spacing.md)
            .padding(.vertical, S0.Theme.Spacing.sm)
            .background(S0.Theme.Colors.background)
            .cornerRadius(S0.Theme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                    .stroke(S0.Theme.Colors.border, lineWidth: 1)
            )
        }
    }
}
