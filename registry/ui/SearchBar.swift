import SwiftUI

// MARK: - S0 SearchBar

extension S0 {
    public struct SearchBar: View {
        @Binding private var text: String
        private let placeholder: String
        private let onSubmit: (() -> Void)?

        public init(
            text: Binding<String>,
            placeholder: String = "Search...",
            onSubmit: (() -> Void)? = nil
        ) {
            self._text = text
            self.placeholder = placeholder
            self.onSubmit = onSubmit
        }

        public var body: some View {
            HStack(spacing: S0.Theme.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                    .font(.system(size: 16))

                TextField(placeholder, text: $text)
                    .font(S0.Theme.Typography.body)
                    .foregroundColor(S0.Theme.Colors.foreground)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button {
                        withAnimation(S0.Theme.Animation.fast) {
                            text = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                }
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
