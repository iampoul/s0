import SwiftUI

extension S0 {
    
    public struct Tabs<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            content
        }
    }
    
    public struct TabList<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            HStack(spacing: 0) {
                content
            }
            .background(S0.Theme.Colors.muted)
            .cornerRadius(S0.Theme.Radius.md)
            .padding(.horizontal)
        }
    }
    
    public struct TabTrigger: View {
        private let label: String
        private let isSelected: Bool
        private let action: () -> Void
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        
        public init(_ label: String, isSelected: Bool, action: @escaping () -> Void) {
            self.label = label
            self.isSelected = isSelected
            self.action = action
        }
        
        public var body: some View {
            SwiftUI.Button(action: action) {
                Text(label)
                    .font(S0.Theme.Typography.button)
                    .foregroundColor(isSelected ? S0.Theme.Colors.foreground : S0.Theme.Colors.mutedForeground)
                    .padding(.horizontal, S0.Theme.Spacing.md)
                    .padding(.vertical, S0.Theme.Spacing.sm)
                    .background(isSelected ? S0.Theme.Colors.background : Color.clear)
                    .cornerRadius(S0.Theme.Radius.sm)
                    .animation(reduceMotion ? nil : S0.Theme.Animation.fast, value: isSelected)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(label)
            .accessibilityValue(isSelected ? "Selected" : "")
        }
    }
    
    public struct TabContent<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            content
                .padding(.top, S0.Theme.Spacing.lg)
        }
    }
}
