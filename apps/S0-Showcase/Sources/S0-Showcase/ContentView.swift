import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    
                    // Buttons Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Buttons")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            S0.Button("Primary Button") {
                                print("Primary tapped")
                            }
                            .variant(.default)
                            
                            S0.Button("Secondary Button") {
                                print("Secondary tapped")
                            }
                            .variant(.secondary)
                            
                            S0.Button("Destructive") {
                                print("Destructive tapped")
                            }
                            .variant(.destructive)
                            
                            S0.Button("Outline Button") {
                                print("Outline tapped")
                            }
                            .variant(.outline)
                            
                            S0.Button("Ghost Button") {
                                print("Ghost tapped")
                            }
                            .variant(.ghost)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Card Showcase
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cards")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        S0.Card {
                            S0.Card.Header {
                                S0.Card.Title("Project Status")
                                S0.Card.Description("Track your current build progress.")
                            }
                            
                            S0.Card.Content {
                                Text("Deployment in progress: 84%")
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                            
                            S0.Card.Footer {
                                HStack {
                                    Spacer()
                                    S0.Button("Cancel") {}
                                        .variant(.ghost)
                                        .size(.sm)
                                    S0.Button("View Logs") {}
                                        .variant(.outline)
                                        .size(.sm)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Sizes
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sizes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            S0.Button("Small") {}
                                .size(.sm)
                            
                            S0.Button("Default") {}
                                .size(.default)
                            
                            S0.Button("Large") {}
                                .size(.lg)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
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
