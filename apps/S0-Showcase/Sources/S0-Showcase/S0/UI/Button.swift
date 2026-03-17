import SwiftUI

extension S0 {
    
    public struct Button<Label: View>: View {
        
        // 1. Configuration Enums (The "Props")
        public enum Variant {
            case `default`
            case secondary
            case destructive
            case outline
            case ghost
            case link
        }
        
        public enum Size {
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
            
            var padding: CGFloat {
                switch self {
                case .default: return 16
                case .sm: return 12
                case .lg: return 32
                case .icon: return 0 // Centered
                }
            }
        }
        
        // 2. Properties
        private let variant: Variant
        private let size: Size
        private let action: () -> Void
        private let label: () -> Label
        
        // 3. Initializer (Mimics native SwiftUI)
        public init(
            variant: Variant = .default,
            size: Size = .default,
            action: @escaping () -> Void,
            @ViewBuilder label: @escaping () -> Label
        ) {
            self.variant = variant
            self.size = size
            self.action = action
            self.label = label
        }
        
        // 4. Convenience Init for String titles
        public init(
            _ title: String,
            variant: Variant = .default,
            size: Size = .default,
            action: @escaping () -> Void
        ) where Label == Text {
            self.variant = variant
            self.size = size
            self.action = action
            self.label = { Text(title) }
        }
        
        // 5. The Body
        public var body: some View {
            SwiftUI.Button(action: action, label: label)
                .buttonStyle(S0ButtonStyle(variant: variant, size: size))
        }
    }
}

// 6. The Style Engine (Internal Logic)
fileprivate struct S0ButtonStyle: ButtonStyle {
    let variant: S0.Button<AnyView>.Variant
    let size: S0.Button<AnyView>.Size
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(S0.Theme.Typography.button)
            .padding(.horizontal, size.padding)
            .frame(height: size.height)
            .frame(minWidth: size == .icon ? size.height : 0) // Ensure square for icons
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor(isPressed: configuration.isPressed))
            .cornerRadius(S0.Theme.radius)
            .overlay(
                RoundedRectangle(cornerRadius: S0.Theme.radius)
                    .stroke(borderColor, lineWidth: variant == .outline ? 1 : 0)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0) // Subtle feedback
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // "Tactile" click feel
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
    
    // MARK: - Token Mapping
    
    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .default:      return S0.Theme.Colors.primary
        case .secondary:    return S0.Theme.Colors.secondary
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
