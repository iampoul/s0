import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var textAreaText = ""
    @State private var toggleOn = true
    @State private var progress = 0.65
    @State private var checkboxOn = false
    @State private var radioSelection = "option1"
    @State private var selectValue = "swift"
    @State private var sliderValue = 0.5
    @State private var stepperValue = 3
    @State private var selectedTab = 0
    @State private var showSheet = false
    @State private var showToast = false
    
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
                    
                    // Forms
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Form Controls")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                            S0.Label("Terms", required: true)
                            S0.Checkbox("I agree to the terms", isChecked: $checkboxOn)
                            
                            S0.Separator()
                            
                            S0.Label("Notification Preference")
                            S0.RadioGroup(selection: $radioSelection, options: [
                                (value: "option1", label: "Email"),
                                (value: "option2", label: "Push"),
                                (value: "option3", label: "None"),
                            ])
                            
                            S0.Separator()
                            
                            S0.Select("Language", selection: $selectValue, options: [
                                (value: "swift", label: "Swift"),
                                (value: "kotlin", label: "Kotlin"),
                                (value: "dart", label: "Dart"),
                            ])
                            
                            S0.Slider("Volume", value: $sliderValue)
                            
                            S0.Stepper("Quantity", value: $stepperValue, in: 0...10)
                            
                            S0.TextArea("Notes", text: $textAreaText, placeholder: "Write something...")
                        }
                        .padding(S0.Theme.Spacing.lg)
                        .background(S0.Theme.Colors.secondaryBackground)
                        .cornerRadius(S0.Theme.Radius.lg)
                        .padding(.horizontal)
                    }
                    
                    // Alerts
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Alerts")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: S0.Theme.Spacing.md) {
                            S0.Alert {
                                S0.AlertTitle("Heads up!")
                                S0.AlertDescription("This is an informational alert.")
                            }
                            
                            S0.Alert(variant: .destructive) {
                                S0.AlertTitle("Error")
                                S0.AlertDescription("Something went wrong.")
                            }
                            
                            S0.Alert(variant: .success) {
                                S0.AlertTitle("Success")
                                S0.AlertDescription("Operation completed.")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Tabs
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Tabs")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            S0.TabList {
                                S0.TabTrigger("Account", isSelected: selectedTab == 0) { selectedTab = 0 }
                                S0.TabTrigger("Password", isSelected: selectedTab == 1) { selectedTab = 1 }
                                S0.TabTrigger("Settings", isSelected: selectedTab == 2) { selectedTab = 2 }
                            }
                            
                            S0.TabContent {
                                Group {
                                    switch selectedTab {
                                    case 0: Text("Manage your account settings.")
                                    case 1: Text("Change your password here.")
                                    default: Text("Configure your preferences.")
                                    }
                                }
                                .font(S0.Theme.Typography.body)
                                .foregroundColor(S0.Theme.Colors.mutedForeground)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Accordion
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Accordion")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            S0.Accordion("Is it accessible?") {
                                Text("Yes. It adheres to WAI-ARIA design patterns.")
                                    .font(S0.Theme.Typography.subheadline)
                                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                            }
                            S0.Accordion("Is it styled?") {
                                Text("Yes. It uses S0 theme tokens throughout.")
                                    .font(S0.Theme.Typography.subheadline)
                                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                            }
                            S0.Accordion("Is it animated?") {
                                Text("Yes. Smooth expand/collapse with theme animations.")
                                    .font(S0.Theme.Typography.subheadline)
                                    .foregroundColor(S0.Theme.Colors.mutedForeground)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Dropdown, Sheet, Toast
                    VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                        Text("Interactive")
                            .font(S0.Theme.Typography.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: S0.Theme.Spacing.md) {
                            S0.DropdownMenu("Actions", items: [
                                .item("Edit", icon: "pencil") {},
                                .item("Duplicate", icon: "doc.on.doc") {},
                                .divider,
                                .destructive("Delete", icon: "trash") {},
                            ])
                            .font(S0.Theme.Typography.button)
                            
                            S0.Button("Sheet", variant: .outline, size: .sm) { showSheet = true }
                            
                            S0.Button("Toast", variant: .outline, size: .sm) {
                                withAnimation(S0.Theme.Animation.default) { showToast = true }
                            }
                        }
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
            .s0Sheet(isPresented: $showSheet) {
                VStack(alignment: .leading, spacing: S0.Theme.Spacing.lg) {
                    Text("Sheet Content")
                        .font(S0.Theme.Typography.title)
                    Text("This is a bottom sheet with drag indicator and detents.")
                        .font(S0.Theme.Typography.body)
                        .foregroundColor(S0.Theme.Colors.mutedForeground)
                    Spacer()
                }
            }
            .overlay(alignment: .top) {
                S0.Toast("Action completed!", variant: .success, isPresented: $showToast)
                    .padding(.horizontal)
                    .padding(.top, S0.Theme.Spacing.sm)
            }
        }
    }
}

#Preview {
    ContentView()
}
