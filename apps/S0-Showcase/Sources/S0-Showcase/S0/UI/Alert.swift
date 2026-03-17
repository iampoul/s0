import SwiftUI

extension S0 {
    
    public struct Alert<Content: View>: View {
        private let variant: AlertVariant
        private let content: Content
        
        public init(variant: AlertVariant = .default, @ViewBuilder content: () -> Content) {
            self.variant = variant
            self.content = content()
        }
        
        public var body: some View {
            HStack(alignment: .top, spacing: S0.Theme.Spacing.md) {
                if let icon = variant.icon {
                    Image(systemName: icon)
                        .font(S0.Theme.Typography.body)
                        .foregroundColor(variant.iconColor)
                }
                
                VStack(alignment: .leading, spacing: S0.Theme.Spacing.xs) {
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(S0.Theme.Spacing.lg)
            .background(variant.backgroundColor)
            .cornerRadius(S0.Theme.Radius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.Radius.lg)
                    .stroke(variant.borderColor, lineWidth: 1)
            )
        }
    }
    
    public enum AlertVariant {
        case `default`
        case destructive
        case success
        case warning
        
        var icon: String? {
            switch self {
            case .default:     return "info.circle"
            case .destructive: return "exclamationmark.triangle"
            case .success:     return "checkmark.circle"
            case .warning:     return "exclamationmark.circle"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .default:     return S0.Theme.Colors.foreground
            case .destructive: return S0.Theme.Colors.destructive
            case .success:     return S0.Theme.Colors.success
            case .warning:     return S0.Theme.Colors.warning
            }
        }
        
        var backgroundColor: Color {
            return S0.Theme.Colors.background
        }
        
        var borderColor: Color {
            switch self {
            case .default:     return S0.Theme.Colors.border
            case .destructive: return S0.Theme.Colors.destructive.opacity(0.5)
            case .success:     return S0.Theme.Colors.success.opacity(0.5)
            case .warning:     return S0.Theme.Colors.warning.opacity(0.5)
            }
        }
    }
    
    public struct AlertTitle: View {
        private let text: String
        
        public init(_ text: String) {
            self.text = text
        }
        
        public var body: some View {
            Text(text)
                .font(S0.Theme.Typography.button)
                .foregroundColor(S0.Theme.Colors.foreground)
        }
    }
    
    public struct AlertDescription: View {
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
