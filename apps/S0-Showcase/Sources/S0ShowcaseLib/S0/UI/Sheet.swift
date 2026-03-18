import SwiftUI

extension S0 {
    
    public struct Sheet<SheetContent: View>: ViewModifier {
        @Binding private var isPresented: Bool
        private let sheetContent: SheetContent
        
        public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> SheetContent) {
            self._isPresented = isPresented
            self.sheetContent = content()
        }
        
        public func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    NavigationStack {
                        sheetContent
                            .padding(S0.Theme.Spacing.lg)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    SwiftUI.Button("Done") {
                                        isPresented = false
                                    }
                                    .font(S0.Theme.Typography.button)
                                    .foregroundColor(S0.Theme.Colors.primary)
                                }
                            }
                    }
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }
        }
    }
}

extension View {
    public func s0Sheet<SheetContent: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        self.modifier(S0.Sheet(isPresented: isPresented, content: content))
    }
}
