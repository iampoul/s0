import SwiftUI

// MARK: - S0 NavigationBar

extension S0 {
    public struct NavigationBar<Leading: View, Trailing: View>: View {
        private let title: String
        private let subtitle: String?
        private let leading: Leading
        private let trailing: Trailing

        public init(
            title: String,
            subtitle: String? = nil,
            @ViewBuilder leading: () -> Leading = { EmptyView() },
            @ViewBuilder trailing: () -> Trailing = { EmptyView() }
        ) {
            self.title = title
            self.subtitle = subtitle
            self.leading = leading()
            self.trailing = trailing()
        }

        public var body: some View {
            HStack(spacing: S0.Theme.Spacing.md) {
                leading

                VStack(spacing: 2) {
                    Text(title)
                        .font(S0.Theme.Typography.headline)
                        .foregroundColor(S0.Theme.Colors.foreground)

                    if let subtitle {
                        Text(subtitle)
                            .font(S0.Theme.Typography.caption)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                    }
                }
                .frame(maxWidth: .infinity)

                trailing
            }
            .padding(.horizontal, S0.Theme.Spacing.lg)
            .padding(.vertical, S0.Theme.Spacing.md)
            .background(S0.Theme.Colors.background)
            .overlay(alignment: .bottom) {
                S0.Separator()
            }
        }
    }
}
