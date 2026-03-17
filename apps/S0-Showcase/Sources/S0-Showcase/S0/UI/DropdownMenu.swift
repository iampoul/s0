import SwiftUI

extension S0 {
    
    public struct DropdownMenu<Label: View>: View {
        private let label: () -> Label
        private let items: [DropdownItem]
        
        public init(items: [DropdownItem], @ViewBuilder label: @escaping () -> Label) {
            self.label = label
            self.items = items
        }
        
        public init(_ title: String, items: [DropdownItem]) where Label == Text {
            self.label = { Text(title) }
            self.items = items
        }
        
        public var body: some View {
            Menu {
                ForEach(0..<items.count, id: \.self) { index in
                    let item = items[index]
                    if item.isDivider {
                        Divider()
                    } else {
                        SwiftUI.Button(role: item.isDestructive ? .destructive : nil) {
                            item.action?()
                        } label: {
                            if let icon = item.icon {
                                SwiftUI.Label(item.title, systemImage: icon)
                            } else {
                                Text(item.title)
                            }
                        }
                    }
                }
            } label: {
                label()
            }
        }
    }
    
    public struct DropdownItem {
        let title: String
        let icon: String?
        let isDestructive: Bool
        let isDivider: Bool
        let action: (() -> Void)?
        
        public static func item(_ title: String, icon: String? = nil, action: @escaping () -> Void) -> DropdownItem {
            DropdownItem(title: title, icon: icon, isDestructive: false, isDivider: false, action: action)
        }
        
        public static func destructive(_ title: String, icon: String? = nil, action: @escaping () -> Void) -> DropdownItem {
            DropdownItem(title: title, icon: icon, isDestructive: true, isDivider: false, action: action)
        }
        
        public static var divider: DropdownItem {
            DropdownItem(title: "", icon: nil, isDestructive: false, isDivider: true, action: nil)
        }
    }
}
