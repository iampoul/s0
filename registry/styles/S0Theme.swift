import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// The Namespace
public enum S0 {
    
    // MARK: - Design Tokens
    
    public struct Theme {
        
        // MARK: Radius
        
        public struct Radius {
            public static let sm: CGFloat = 4
            public static let md: CGFloat = 8
            public static let lg: CGFloat = 12
            public static let xl: CGFloat = 16
            public static let full: CGFloat = 9999
        }
        
        /// Default corner radius used by components
        public static let radius: CGFloat = Radius.md
        
        // MARK: Spacing
        
        public struct Spacing {
            public static let xxs: CGFloat = 2
            public static let xs: CGFloat = 4
            public static let sm: CGFloat = 8
            public static let md: CGFloat = 12
            public static let lg: CGFloat = 16
            public static let xl: CGFloat = 24
            public static let xxl: CGFloat = 32
        }
        
        // MARK: Colors
        
        public struct Colors {
            public static let primary = Color.primary
            public static let secondary = Color.secondary
            
            #if canImport(UIKit)
            public static let primaryForeground = Color(uiColor: .systemBackground)
            public static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
            public static let muted = Color(uiColor: .tertiarySystemFill)
            public static let border = Color(uiColor: .separator)
            public static let background = Color(uiColor: .systemBackground)
            public static let card = Color(uiColor: .systemBackground)
            #elseif canImport(AppKit)
            public static let primaryForeground = Color(nsColor: .windowBackgroundColor)
            public static let secondaryBackground = Color(nsColor: .controlBackgroundColor)
            public static let muted = Color(nsColor: .underPageBackgroundColor)
            public static let border = Color(nsColor: .separatorColor)
            public static let background = Color(nsColor: .windowBackgroundColor)
            public static let card = Color(nsColor: .windowBackgroundColor)
            #endif
            
            public static let secondaryForeground = Color.primary
            
            public static let destructive = Color.red
            public static let destructiveForeground = Color.white
            
            public static let success = Color.green
            public static let successForeground = Color.white
            
            public static let warning = Color.orange
            public static let warningForeground = Color.white
            
            public static let mutedForeground = Color.secondary
            public static let foreground = Color.primary
            public static let cardForeground = Color.primary
        }
        
        // MARK: Typography
        
        public struct Typography {
            public static let largeTitle = Font.largeTitle.weight(.bold)
            public static let title = Font.title2.weight(.bold)
            public static let headline = Font.headline
            public static let body = Font.body
            public static let callout = Font.callout
            public static let subheadline = Font.subheadline
            public static let footnote = Font.footnote
            public static let caption = Font.caption
            public static let button = Font.callout.weight(.medium)
        }
        
        // MARK: Shadows
        
        public struct Shadow {
            public let color: Color
            public let radius: CGFloat
            public let x: CGFloat
            public let y: CGFloat
            
            public static let sm = Shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            public static let md = Shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
            public static let lg = Shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
        }
        
        // MARK: Animation
        
        public struct Animation {
            public static let fast: SwiftUI.Animation = .easeOut(duration: 0.1)
            public static let `default`: SwiftUI.Animation = .easeOut(duration: 0.2)
            public static let slow: SwiftUI.Animation = .easeInOut(duration: 0.35)
            public static let spring: SwiftUI.Animation = .spring(response: 0.35, dampingFraction: 0.7)
        }
    }
}

// MARK: - Shadow View Modifier

extension View {
    public func s0Shadow(_ shadow: S0.Theme.Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
