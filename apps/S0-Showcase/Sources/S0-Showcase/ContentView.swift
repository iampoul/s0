import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: S0.Theme.Spacing.xxl) {
                    
                    // Buttons Section
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Buttons")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Button("Primary Button", variant: .default) {
                                print("Primary tapped")
                            }
                            
                            S0.Button("Secondary Button", variant: .secondary) {
                                print("Secondary tapped")
                            }
                            
                            S0.Button("Destructive", variant: .destructive) {
                                print("Destructive tapped")
                            }
                            
                            S0.Button("Outline Button", variant: .outline) {
                                print("Outline tapped")
                            }
                            
                            S0.Button("Ghost Button", variant: .ghost) {
                                print("Ghost tapped")
                            }
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                    
                    // Card Showcase
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Cards")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        S0.Card {
                            S0.CardHeader {
                                S0.CardTitle("Project Status")
                                S0.CardDescription("Track your current build progress.")
                            }
                            
                            S0.CardContent {
                                Text("Deployment in progress: 84%")
                                    .font(S0.Theme.Typography.button)
                                    .foregroundColor(S0.Theme.Colors.foreground)
                            }
                            
                            S0.CardFooter {
                                HStack {
                                    Spacer()
                                    S0.Button("Cancel", variant: .ghost, size: .sm) {}
                                    S0.Button("View Logs", variant: .outline, size: .sm) {}
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Sizes
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Sizes")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Button("Small", size: .sm) {}
                            S0.Button("Default") {}
                            S0.Button("Large", size: .lg) {}
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                    
                    // Input Showcase
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Inputs")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Input("Email", text: $inputText, placeholder: "you@example.com")
                            S0.Input(text: $inputText, placeholder: "Without label")
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("S0 Components")
        }
    }
}

#Preview {
    ContentView()
}
