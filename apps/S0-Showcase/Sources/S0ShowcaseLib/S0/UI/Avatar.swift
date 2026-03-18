import SwiftUI

extension S0 {
    
    public enum AvatarSize {
        case sm
        case `default`
        case lg
        
        var dimension: CGFloat {
            switch self {
            case .sm:      return 32
            case .default: return 40
            case .lg:      return 56
            }
        }
        
        var font: Font {
            switch self {
            case .sm:      return S0.Theme.Typography.caption
            case .default: return S0.Theme.Typography.button
            case .lg:      return S0.Theme.Typography.headline
            }
        }
    }
    
    public struct Avatar: View {
        private let image: Image?
        private let initials: String
        private let size: AvatarSize
        
        public init(image: Image? = nil, initials: String = "", size: AvatarSize = .default) {
            self.image = image
            self.initials = String(initials.prefix(2)).uppercased()
            self.size = size
        }
        
        public var body: some View {
            Group {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Text(initials)
                        .font(size.font)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                }
            }
            .frame(width: size.dimension, height: size.dimension)
            .background(S0.Theme.Colors.muted)
            .clipShape(Circle())
        }
    }
}
