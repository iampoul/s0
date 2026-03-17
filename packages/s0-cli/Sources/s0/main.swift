import Foundation
import ArgumentParser

@main
struct S0: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "s0",
        abstract: "The S0 CLI - A toolkit for SwiftUI components.",
        subcommands: [Init.self, Add.self],
        defaultSubcommand: Init.self
    )
}

struct Registry: Codable {
    struct Component: Codable {
        let name: String
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

// The Namespace
public enum S0 {
    
    // The Design Tokens
    public struct Theme {
        public static let radius: CGFloat = 8.0 // "Hard" but polished
        
        public struct Colors {
            // Semantic Names
            public static let primary = Color.primary
            public static let primaryForeground = Color(.systemBackground)
            
            public static let secondary = Color(.secondarySystemBackground)
            public static let secondaryForeground = Color.primary
            
            public static let destructive = Color.red
            public static let destructiveForeground = Color.white
            
            public static let muted = Color(.tertiarySystemFill)
            public static let border = Color(.separator)
            
            public static let background = Color(.systemBackground)
        }
        
        public struct Typography {
            public static let button = Font.system(size: 14, weight: .medium, design: .default)
        }
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
}
