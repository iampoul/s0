import SwiftUI

// The Namespace
public enum S0 {
    
    // The Design Tokens
    public struct Theme {
        public static let radius: CGFloat = 8.0 // "Hard" but polished
        
        public struct Colors {
            // Semantic Names
            public static let primary = Color.primary
            public static let primaryForeground = Color(.systemBackground)
            
            public static let secondary = Color(.secondarySystemBackground)
            public static let secondaryForeground = Color.primary
            
            public static let destructive = Color.red
            public static let destructiveForeground = Color.white
            
            public static let muted = Color(.tertiarySystemFill)
            public static let border = Color(.separator)
            
            public static let background = Color(.systemBackground)
        }
        
        public struct Typography {
            public static let button = Font.system(size: 14, weight: .medium, design: .default)
        }
    }
}
