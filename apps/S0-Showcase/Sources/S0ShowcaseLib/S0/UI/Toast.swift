import SwiftUI

extension S0 {
    
    public enum ToastVariant {
        case `default`
        case success
        case destructive
        case warning
        
        var icon: String {
            switch self {
            case .default:     return "info.circle.fill"
            case .success:     return "checkmark.circle.fill"
            case .destructive: return "xmark.circle.fill"
            case .warning:     return "exclamationmark.circle.fill"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .default:     return S0.Theme.Colors.primary
            case .success:     return S0.Theme.Colors.success
            case .destructive: return S0.Theme.Colors.destructive
            case .warning:     return S0.Theme.Colors.warning
            }
        }
    }
    
    public struct Toast: View {
        private let message: String
        private let variant: ToastVariant
        @Binding private var isPresented: Bool
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        
        public init(_ message: String, variant: ToastVariant = .default, isPresented: Binding<Bool>) {
            self.message = message
            self.variant = variant
            self._isPresented = isPresented
        }
        
        public var body: some View {
            if isPresented {
                HStack(spacing: S0.Theme.Spacing.sm) {
                    Image(systemName: variant.icon)
                        .foregroundColor(variant.iconColor)
                    
                    Text(message)
                        .font(S0.Theme.Typography.button)
                        .foregroundColor(S0.Theme.Colors.foreground)
                    
                    Spacer()
                    
                    SwiftUI.Button {
                        withAnimation(reduceMotion ? nil : S0.Theme.Animation.default) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(S0.Theme.Typography.caption)
                            .foregroundColor(S0.Theme.Colors.mutedForeground)
                    }
                    .buttonStyle(.plain)
                }
                .padding(S0.Theme.Spacing.lg)
                .background(S0.Theme.Colors.background)
                .cornerRadius(S0.Theme.Radius.lg)
                .s0Shadow(.md)
                .overlay(
                    RoundedRectangle(cornerRadius: S0.Theme.Radius.lg)
                        .stroke(S0.Theme.Colors.border, lineWidth: 1)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .accessibilityLabel(message)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(reduceMotion ? nil : S0.Theme.Animation.default) {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}
