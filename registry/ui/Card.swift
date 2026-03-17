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
            .background(S0.Theme.Colors.background)
            .cornerRadius(S0.Theme.radius)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.radius)
                    .stroke(S0.Theme.Colors.border, lineWidth: 1)
            )
        }
    }
}

// Subcomponents for Card
extension S0.Card {
    public struct Header<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                content
            }
            .padding()
        }
    }
    
    public struct Content<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    public struct Footer<Content: View>: View {
        private let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                    .background(S0.Theme.Colors.border)
                content
                    .padding()
            }
        }
    }
    
    public struct Title: View {
        private let text: String
        
        public init(_ text: String) {
            self.text = text
        }
        
        public var body: some View {
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    public struct Description: View {
        private let text: String
        
        public init(_ text: String) {
            self.text = text
        }
        
        public var body: some View {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
}
