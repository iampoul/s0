import SwiftUI

// MARK: - S0 Dialog

extension S0 {
    public struct Dialog<DialogContent: View>: ViewModifier {
        @Binding private var isPresented: Bool
        private let title: String
        private let description: String?
        private let dialogContent: DialogContent
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        public init(
            isPresented: Binding<Bool>,
            title: String,
            description: String? = nil,
            @ViewBuilder content: () -> DialogContent
        ) {
            self._isPresented = isPresented
            self.title = title
            self.description = description
            self.dialogContent = content()
        }

        public func body(content: Content) -> some View {
            content
                .overlay {
                    if isPresented {
                        // Backdrop
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture { isPresented = false }
                            .transition(.opacity)
                            .accessibilityHidden(true)

                        // Dialog
                        VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                                Text(title)
                                    .font(S0.Theme.Typography.headline)
                                    .foregroundColor(S0.Theme.Colors.foreground)

                                if let description {
                                    Text(description)
                                        .font(S0.Theme.Typography.body)
                                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                                }
                            }

                            dialogContent
                        }
                        .padding(S0.Theme.Spacing.xl)
                        .background(S0.Theme.Colors.background)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .s0Shadow(.lg)
                        .padding(.horizontal, S0.Theme.Spacing.xxl)
                        .transition(.scale.combined(with: .opacity))
                        .accessibilityAddTraits(.isModal)
                    }
                }
                .animation(reduceMotion ? nil : S0.Theme.Animation.default, value: isPresented)
        }
    }

    public struct DialogActions: View {
        private let children: AnyView

        public init<Content: View>(@ViewBuilder content: () -> Content) {
            self.children = AnyView(content())
        }

        public var body: some View {
            HStack(spacing: S0.Theme.Spacing.sm) {
                Spacer()
                children
            }
        }
    }
}

extension View {
    public func s0Dialog<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        description: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        self.modifier(
            S0.Dialog(
                isPresented: isPresented,
                title: title,
                description: description,
                content: content
            )
        )
    }
}
