import SwiftUI

extension S0 {
    
    public enum BadgeVariant {
        case `default`
        case secondary
        case destructive
        case outline
        
        var backgroundColor: Color {
            switch self {
            case .default:     return S0.Theme.Colors.primary
            case .secondary:   return S0.Theme.Colors.secondaryBackground
            case .destructive: return S0.Theme.Colors.destructive
            case .outline:     return Color.clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .default:     return S0.Theme.Colors.primaryForeground
            case .secondary:   return S0.Theme.Colors.secondaryForeground
            case .destructive: return S0.Theme.Colors.destructiveForeground
            case .outline:     return S0.Theme.Colors.foreground
            }
        }
        
        var borderColor: Color {
            switch self {
            case .outline: return S0.Theme.Colors.border
            default:       return Color.clear
            }
        }
    }
    
    public struct Badge: View {
        private let text: String
        private let variant: BadgeVariant
        
        public init(_ text: String, variant: BadgeVariant = .default) {
            self.text = text
            self.variant = variant
        }
        
        public var body: some View {
            Text(text)
                .font(S0.Theme.Typography.caption)
                .padding(.horizontal, S0.Theme.Spacing.sm)
                .padding(.vertical, S0.Theme.Spacing.xxs)
                .background(variant.backgroundColor)
                .foregroundColor(variant.foregroundColor)
                .cornerRadius(S0.Theme.Radius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.full)
                        .stroke(variant.borderColor, lineWidth: variant == .outline ? 1 : 0)
                )
        }
    }
}
