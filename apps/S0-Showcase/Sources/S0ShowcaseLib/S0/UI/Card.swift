import SwiftUI

extension S0 {
    public struct Card<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .background(S0.Theme.Colors.card)
            .cornerRadius(S0.Theme.Radius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.lg)
                    .stroke(S0.Theme.Colors.border, lineWidth: 1)
            )
            .s0Shadow(.sm)
        }
    }
    
    public struct CardHeader<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                content
            }
            .padding(S0.Theme.Spacing.lg)
        }
    }
    
    public struct CardContent<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .padding(.horizontal, S0.Theme.Spacing.lg)
            .padding(.bottom, S0.Theme.Spacing.lg)
        }
    }
    
    public struct CardFooter<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                    .background(S0.Theme.Colors.border)
                content
                    .padding(S0.Theme.Spacing.lg)
            }
        }
    }
    
    public struct CardTitle: View {
        private let text: String
        
        public init(_ text: String) {
            self.text = text
        }
        
        public var body: some View {
            Text(text)
                .font(S0.Theme.Typography.headline)
                .foregroundColor(S0.Theme.Colors.cardForeground)
        }
    }
    
    public struct CardDescription: View {
        private let text: String
        
        public init(_ text: String) {
            self.text = text
        }
        
        public var body: some View {
            Text(text)
                .font(S0.Theme.Typography.subheadline)
                .foregroundColor(S0.Theme.Colors.mutedForeground)
        }
    }
}
