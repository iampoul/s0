import SwiftUI

extension S0 {
    
    public enum ButtonVariant {
        case `default`
        case secondary
        case destructive
        case outline
        case ghost
        case link
    }
    
    public enum ButtonSize {
        case `default`
        case sm
        case lg
        case icon
        
        var height: CGFloat {
            switch self {
            case .default: return 40
            case .sm: return 36
            case .lg: return 44
            case .icon: return 40
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .default: return S0.Theme.Spacing.lg
            case .sm: return S0.Theme.Spacing.md
            case .lg: return S0.Theme.Spacing.xxl
            case .icon: return 0
            }
        }
    }
    
    public struct Button<Label: View>: View {
        
        private let variant: ButtonVariant
        private let size: ButtonSize
        private let action: () -> Void
        private let label: () -> Label
        
        public init(
            variant: ButtonVariant = .default,
            size: ButtonSize = .default,
            action: @escaping () -> Void,
            @ViewBuilder label: @escaping () -> Label
        ) {
            self.variant = variant
            self.size = size
            self.action = action
            self.label = label
        }
        
        public init(
            _ title: String,
            variant: ButtonVariant = .default,
            size: ButtonSize = .default,
            action: @escaping () -> Void
        ) where Label == Text {
            self.variant = variant
            self.size = size
            self.action = action
            self.label = { Text(title) }
        }
        
        public var body: some View {
            SwiftUI.Button(action: action, label: label)
                .buttonStyle(S0ButtonStyle(variant: variant, size: size))
        }
    }
}

fileprivate struct S0ButtonStyle: ButtonStyle {
    let variant: S0.ButtonVariant
    let size: S0.ButtonSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(S0.Theme.Typography.button)
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .frame(minWidth: size == .icon ? size.height : 0)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .cornerRadius(S0.Theme.radius)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.radius)
                    .stroke(borderColor, lineWidth: variant == .outline ? 1 : 0)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(S0.Theme.Animation.fast, value: configuration.isPressed)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .default:      return S0.Theme.Colors.primary
        case .secondary:    return S0.Theme.Colors.secondaryBackground
        case .destructive:  return S0.Theme.Colors.destructive
        case .outline:      return Color.clear
        case .ghost:        return isPressed ? S0.Theme.Colors.muted : Color.clear
        case .link:         return Color.clear
        }
    }
    
    private func foregroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .default:      return S0.Theme.Colors.primaryForeground
        case .secondary:    return S0.Theme.Colors.secondaryForeground
        case .destructive:  return S0.Theme.Colors.destructiveForeground
        case .outline:      return S0.Theme.Colors.primary
        case .ghost:        return S0.Theme.Colors.primary
        case .link:         return S0.Theme.Colors.primary
        }
    }
    
    private var borderColor: Color {
        if variant == .outline { return S0.Theme.Colors.border }
        return Color.clear
    }
}
