import SwiftUI

extension S0 {
    
    public struct Accordion<Content: View>: View {
        private let title: String
        private let content: Content
        @State private var isExpanded = false
        
        public init(_ title: String, expanded: Bool = false, @ViewBuilder content: () -> Content) {
            self.title = title
            self._isExpanded = State(initialValue: expanded)
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                SwiftUI.Button {
                    withAnimation(S0.Theme.Animation.default) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text(title)
                            .font(S0.Theme.Typography.button)
                            .foregroundColor(S0.Theme.Colors.foreground)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(S0.Theme.Typography.caption)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding(.vertical, S0.Theme.Spacing.lg)
                }
                .buttonStyle(.plain)
                
                if isExpanded {
                    content
                        .padding(.bottom, S0.Theme.Spacing.lg)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                S0.Separator()
            }
        }
    }
}
