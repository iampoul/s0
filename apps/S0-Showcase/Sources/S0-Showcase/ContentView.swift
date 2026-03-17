import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var toggleOn = true
    @State private var progress = 0.65
    
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
                            S0.Button("Primary Button", variant: .default) {}
                            S0.Button("Secondary Button", variant: .secondary) {}
                            S0.Button("Destructive", variant: .destructive) {}
                            S0.Button("Outline Button", variant: .outline) {}
                            S0.Button("Ghost Button", variant: .ghost) {}
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                    
                    // Badges
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Badges")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: S0.Theme.Spacing.sm) {
                            S0.Badge("Default")
                            S0.Badge("Secondary", variant: .secondary)
                            S0.Badge("Destructive", variant: .destructive)
                            S0.Badge("Outline", variant: .outline)
                        }
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
                                S0.Progress(value: progress)
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
                    
                    // Avatars
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Avatars")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: S0.Theme.Spacing.md) {
                            S0.Avatar(initials: "JD", size: .sm)
                            S0.Avatar(initials: "AB", size: .default)
                            S0.Avatar(initials: "XY", size: .lg)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Toggle
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Toggle")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Toggle("Airplane Mode", isOn: $toggleOn)
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                    
                    // Separator
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Separator")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            Text("Above").font(S0.Theme.Typography.body)
                            S0.Separator()
                            Text("Below").font(S0.Theme.Typography.body)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Progress
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Progress")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Progress(value: 0.25)
                            S0.Progress(value: 0.5)
                            S0.Progress(value: 0.75)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Loading States
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Loading States")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: S0.Theme.Spacing.xl) {
                            VStack(spacing: S0.Theme.Spacing.sm) {
                                S0.Spinner()
                                Text("Spinner").font(S0.Theme.Typography.caption)
                            }
                            
                            VStack(alignment: .leading, spacing: S0.Theme.Spacing.sm) {
                                S0.Skeleton(height: 14)
                                S0.Skeleton(width: 120, height: 14)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
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
                    
                    // Sizes
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Button Sizes")
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
