import SwiftUI

extension S0 {
    
    public struct Popover<Label: View, Content: View>: View {
        @State private var isPresented = false
        private let label: () -> Label
        private let content: Content
        
        public init(@ViewBuilder label: @escaping () -> Label, @ViewBuilder content: () -> Content) {
            self.label = label
            self.content = content()
        }
        
        public var body: some View {
            SwiftUI.Button {
                isPresented.toggle()
            } label: {
                label()
            }
            .buttonStyle(.plain)
            .popover(isPresented: $isPresented) {
                content
                    .padding(S0.Theme.Spacing.lg)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}
