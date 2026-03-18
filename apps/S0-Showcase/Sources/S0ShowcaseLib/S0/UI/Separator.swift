import SwiftUI

extension S0 {
    
    public enum SeparatorOrientation {
        case horizontal
        case vertical
    }
    
    public struct Separator: View {
        private let orientation: SeparatorOrientation
        
        public init(_ orientation: SeparatorOrientation = .horizontal) {
            self.orientation = orientation
        }
        
        public var body: some View {
            switch orientation {
            case .horizontal:
                Rectangle()
                    .fill(S0.Theme.Colors.border)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            case .vertical:
                Rectangle()
                    .fill(S0.Theme.Colors.border)
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
            }
        }
    }
}
