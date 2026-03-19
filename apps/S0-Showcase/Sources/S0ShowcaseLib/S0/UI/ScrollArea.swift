import SwiftUI

// MARK: - S0 ScrollArea

extension S0 {
    public enum ScrollAreaAxis {
        case vertical
        case horizontal
        case both
    }

    public struct ScrollArea<Content: View>: View {
        private let axis: ScrollAreaAxis
        private let showsIndicators: Bool
        private let maxHeight: CGFloat?
        private let content: Content

        public init(
            axis: ScrollAreaAxis = .vertical,
            showsIndicators: Bool = true,
            maxHeight: CGFloat? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.axis = axis
            self.showsIndicators = showsIndicators
            self.maxHeight = maxHeight
            self.content = content()
        }

        public var body: some View {
            ScrollView(scrollAxes, showsIndicators: showsIndicators) {
                content
            }
            .frame(maxHeight: maxHeight)
            .background(S0.Theme.Colors.background)
            .cornerRadius(S0.Theme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.md)
                    .stroke(S0.Theme.Colors.border, lineWidth: 1)
            )
        }

        private var scrollAxes: Axis.Set {
            switch axis {
            case .vertical: return .vertical
            case .horizontal: return .horizontal
            case .both: return [.vertical, .horizontal]
            }
        }
    }
}
