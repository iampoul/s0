import SwiftUI

// MARK: - S0 Tooltip

extension S0 {
    public enum TooltipEdge {
        case top, bottom, leading, trailing
    }

    public struct Tooltip: ViewModifier {
        private let message: String
        private let edge: TooltipEdge
        @State private var isVisible: Bool = false

        public init(
            _ message: String,
            edge: TooltipEdge = .top
        ) {
            self.message = message
            self.edge = edge
        }

        public func body(content: Content) -> some View {
            content
                .overlay {
                    if isVisible {
                        tooltipView
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }
                }
                .onHover { hovering in
                    withAnimation(S0.Theme.Animation.fast) {
                        isVisible = hovering
                    }
                }
                #if os(iOS)
                .onLongPressGesture(minimumDuration: 0.5) {
                    withAnimation(S0.Theme.Animation.fast) {
                        isVisible = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(S0.Theme.Animation.fast) {
                            isVisible = false
                        }
                    }
                }
                #endif
        }

        private var tooltipView: some View {
            GeometryReader { geometry in
                Text(message)
                    .font(S0.Theme.Typography.caption)
                    .foregroundColor(S0.Theme.Colors.primaryForeground)
                    .padding(.horizontal, S0.Theme.Spacing.sm)
                    .padding(.vertical, S0.Theme.Spacing.xs)
                    .background(S0.Theme.Colors.foreground)
                    .cornerRadius(S0.Theme.Radius.sm)
                    .fixedSize()
                    .position(
                        x: geometry.size.width / 2,
                        y: edge == .bottom
                            ? geometry.size.height + S0.Theme.Spacing.sm + 12
                            : -S0.Theme.Spacing.sm - 12
                    )
            }
        }
    }
}

extension View {
    public func s0Tooltip(_ message: String, edge: S0.TooltipEdge = .top) -> some View {
        self.modifier(S0.Tooltip(message, edge: edge))
    }
}
