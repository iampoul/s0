import Foundation
import ArgumentParser

@main
struct S0: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "s0",
        abstract: "The S0 CLI - A toolkit for SwiftUI components.",
        subcommands: [Init.self, Add.self, List.self],
        defaultSubcommand: Init.self
    )
}

struct Registry: Codable {
    struct Component: Codable {
        let name: String
        let category: String?
        let description: String?
        let files: [String]
        let dependencies: [String]
    }
    let components: [Component]
}

extension S0 {
    struct Init: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Initialize S0 in your project."
        )

        func run() throws {
            let fileManager = FileManager.default
            let currentPath = fileManager.currentDirectoryPath
            let s0Path = currentPath + "/S0"
            let stylesPath = s0Path + "/Styles"

            print("Creating S0 directory structure...")

            do {
                try fileManager.createDirectory(atPath: stylesPath, withIntermediateDirectories: true)
                
                let themeContent = """
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// The Namespace
public enum S0 {
    
    // MARK: - Design Tokens
    
    public struct Theme {
        
        // MARK: Radius
        
        public struct Radius {
            public static let sm: CGFloat = 4
            public static let md: CGFloat = 8
            public static let lg: CGFloat = 12
            public static let xl: CGFloat = 16
            public static let full: CGFloat = 9999
        }
        
        /// Default corner radius used by components
        public static let radius: CGFloat = Radius.md
        
        // MARK: Spacing
        
        public struct Spacing {
            public static let xxs: CGFloat = 2
            public static let xs: CGFloat = 4
            public static let sm: CGFloat = 8
            public static let md: CGFloat = 12
            public static let lg: CGFloat = 16
            public static let xl: CGFloat = 24
            public static let xxl: CGFloat = 32
        }
        
        // MARK: Colors
        
        public struct Colors {
            public static let primary = Color.primary
            public static let secondary = Color.secondary
            
            #if canImport(UIKit)
            public static let primaryForeground = Color(uiColor: .systemBackground)
            public static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
            public static let muted = Color(uiColor: .tertiarySystemFill)
            public static let border = Color(uiColor: .separator)
            public static let background = Color(uiColor: .systemBackground)
            public static let card = Color(uiColor: .systemBackground)
            #elseif canImport(AppKit)
            public static let primaryForeground = Color(nsColor: .windowBackgroundColor)
            public static let secondaryBackground = Color(nsColor: .controlBackgroundColor)
            public static let muted = Color(nsColor: .underPageBackgroundColor)
            public static let border = Color(nsColor: .separatorColor)
            public static let background = Color(nsColor: .windowBackgroundColor)
            public static let card = Color(nsColor: .windowBackgroundColor)
            #endif
            
            public static let secondaryForeground = Color.primary
            
            public static let destructive = Color.red
            public static let destructiveForeground = Color.white
            
            public static let success = Color.green
            public static let successForeground = Color.white
            
            public static let warning = Color.orange
            public static let warningForeground = Color.white
            
            public static let mutedForeground = Color.secondary
            public static let foreground = Color.primary
            public static let cardForeground = Color.primary
        }
        
        // MARK: Typography
        
        public struct Typography {
            public static let largeTitle = Font.system(size: 34, weight: .bold)
            public static let title = Font.system(size: 22, weight: .bold)
            public static let headline = Font.system(size: 17, weight: .semibold)
            public static let body = Font.system(size: 17, weight: .regular)
            public static let callout = Font.system(size: 16, weight: .regular)
            public static let subheadline = Font.system(size: 15, weight: .regular)
            public static let footnote = Font.system(size: 13, weight: .regular)
            public static let caption = Font.system(size: 12, weight: .regular)
            public static let button = Font.system(size: 14, weight: .medium)
        }
        
        // MARK: Shadows
        
        public struct Shadow {
            public let color: Color
            public let radius: CGFloat
            public let x: CGFloat
            public let y: CGFloat
            
            public static let sm = Shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            public static let md = Shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
            public static let lg = Shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
        }
        
        // MARK: Animation
        
        public struct Animation {
            public static let fast: SwiftUI.Animation = .easeOut(duration: 0.1)
            public static let `default`: SwiftUI.Animation = .easeOut(duration: 0.2)
            public static let slow: SwiftUI.Animation = .easeInOut(duration: 0.35)
            public static let spring: SwiftUI.Animation = .spring(response: 0.35, dampingFraction: 0.7)
        }
    }
}

// MARK: - Shadow View Modifier

extension View {
    public func s0Shadow(_ shadow: S0.Theme.Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
"""
                let themePath = stylesPath + "/S0Theme.swift"
                if !fileManager.fileExists(atPath: themePath) {
                    try themeContent.write(toFile: themePath, atomically: true, encoding: .utf8)
                    print("✓ Created S0/Styles/S0Theme.swift")
                } else {
                    print("! S0Theme.swift already exists, skipping.")
                }

                print("✓ S0 initialized successfully.")
            } catch {
                print("Error: Could not initialize S0: \(error)")
                throw ExitCode.failure
            }
        }
    }

    struct Add: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Add a component to your project."
        )

        @Argument(help: "The name of the component to add.")
        var componentName: String

        @Option(name: .shortAndLong, help: "The local path to the registry (for development).")
        var registryPath: String = "."

        func run() throws {
            let fileManager = FileManager.default
            
            // 1. Read registry.json
            let registryFileUrl = URL(fileURLWithPath: registryPath).appendingPathComponent("registry.json")
            guard let registryData = try? Data(contentsOf: registryFileUrl) else {
                print("Error: Could not find registry.json at \(registryPath)")
                throw ExitCode.failure
            }
            
            let decoder = JSONDecoder()
            guard let registry = try? decoder.decode(Registry.self, from: registryData) else {
                print("Error: Could not parse registry.json")
                throw ExitCode.failure
            }
            
            try addComponent(name: componentName, registry: registry, fileManager: fileManager)
            
            print("✓ Component '\(componentName)' and its dependencies added successfully.")
        }
        
        private func addComponent(name: String, registry: Registry, fileManager: FileManager) throws {
            guard let component = registry.components.first(where: { $0.name.lowercased() == name.lowercased() }) else {
                print("Error: Component '\(name)' not found in registry.")
                return
            }
            
            // 1. Add dependencies first
            for dependency in component.dependencies {
                try addComponent(name: dependency, registry: registry, fileManager: fileManager)
            }
            
            // 2. Ensure S0 directory exists
            let currentPath = fileManager.currentDirectoryPath
            let uiPath = currentPath + "/S0/UI"
            if !fileManager.fileExists(atPath: uiPath) {
                try fileManager.createDirectory(atPath: uiPath, withIntermediateDirectories: true)
            }
            
            // 3. Copy files
            for filePath in component.files {
                let sourceUrl = URL(fileURLWithPath: registryPath).appendingPathComponent(filePath)
                let fileName = sourceUrl.lastPathComponent
                let destinationPath = uiPath + "/" + fileName
                
                if fileManager.fileExists(atPath: destinationPath) {
                    print("! \(fileName) already exists, skipping.")
                    continue
                }
                
                guard let content = try? String(contentsOf: sourceUrl, encoding: .utf8) else {
                    print("Error: Could not read source file at \(sourceUrl.path)")
                    continue
                }
                
                try content.write(toFile: destinationPath, atomically: true, encoding: .utf8)
                print("✓ Added \(fileName) to S0/UI/")
            }
        }
    }

    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "List all available components in the registry."
        )

        @Option(name: .shortAndLong, help: "The local path to the registry (for development).")
        var registryPath: String = "."

        func run() throws {
            let registryFileUrl = URL(fileURLWithPath: registryPath).appendingPathComponent("registry.json")
            guard let registryData = try? Data(contentsOf: registryFileUrl) else {
                print("Error: Could not find registry.json at \(registryPath)")
                print("  Run this from the S0 repo root, or pass --registry-path.")
                throw ExitCode.failure
            }

            let decoder = JSONDecoder()
            guard let registry = try? decoder.decode(Registry.self, from: registryData) else {
                print("Error: Could not parse registry.json")
                throw ExitCode.failure
            }

            if registry.components.isEmpty {
                print("No components found in registry.")
                return
            }

            // Group by category
            var grouped: [String: [Registry.Component]] = [:]
            for component in registry.components {
                let category = component.category ?? "other"
                grouped[category, default: []].append(component)
            }

            print("Available components (\(registry.components.count)):\n")

            for category in grouped.keys.sorted() {
                print("  \(category)")
                for component in grouped[category]! {
                    let desc = component.description.map { " — \($0)" } ?? ""
                    let deps = component.dependencies.isEmpty ? "" : " [requires: \(component.dependencies.joined(separator: ", "))]"
                    print("    \(component.name)\(desc)\(deps)")
                }
                print("")
            }

            print("Add a component with: s0 add <name>")
        }
    }
}
