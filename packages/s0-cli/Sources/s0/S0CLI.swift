import Foundation
import ArgumentParser

// MARK: - Constants

let s0Version = "0.7.0" // x-release-please-version
let defaultRemoteBaseURL = "https://raw.githubusercontent.com/iampoul/s0/main"
let cacheDir: String = {
    let home = FileManager.default.homeDirectoryForCurrentUser.path
    return home + "/.s0/cache"
}()
let cacheTTL: TimeInterval = 3600 // 1 hour

// MARK: - Config

struct S0Config: Codable {
    let registryPath: String?
    let outputPath: String?
    let remote: String?
    
    static func load() -> S0Config? {
        let configPath = FileManager.default.currentDirectoryPath + "/s0.json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
              let config = try? JSONDecoder().decode(S0Config.self, from: data) else {
            return nil
        }
        return config
    }
}

// MARK: - Registry Source

enum RegistrySource {
    case local(String)
    case remote(String)
    
    /// Determine source: explicit --registry-path uses local, otherwise remote.
    static func resolve(registryPath: String?) -> RegistrySource {
        if let path = registryPath {
            // Explicit local path provided
            let resolved = (path == ".") ? (S0Config.load()?.registryPath ?? path) : path
            return .local(resolved)
        }
        // No --registry-path: use remote (or config override)
        if let config = S0Config.load() {
            if let localPath = config.registryPath {
                return .local(localPath)
            }
            if let remote = config.remote {
                return .remote(remote)
            }
        }
        return .remote(defaultRemoteBaseURL)
    }
}

// MARK: - Registry Model

struct Registry: Codable {
    struct Component: Codable {
        let name: String
        let category: String?
        let description: String?
        let version: String?
        let files: [String]
        let dependencies: [String]
    }
    let version: String?
    let components: [Component]
    
    static func load(from source: RegistrySource) throws -> Registry {
        let data: Data
        switch source {
        case .local(let path):
            let url = URL(fileURLWithPath: path).appendingPathComponent("registry.json")
            guard let d = try? Data(contentsOf: url) else {
                print("Error: Could not find registry.json at \(path)")
                print("  Run this from the S0 repo root, or pass --registry-path.")
                throw ExitCode.failure
            }
            data = d
        case .remote(let baseURL):
            let urlString = baseURL + "/registry.json"
            data = try fetchRemote(urlString: urlString, cacheKey: "registry.json")
        }
        guard let registry = try? JSONDecoder().decode(Registry.self, from: data) else {
            print("Error: Could not parse registry.json")
            throw ExitCode.failure
        }
        return registry
    }
}

// MARK: - Theme Model

struct ThemeColors: Codable {
    let background: String
    let foreground: String
    let card: String
    let cardForeground: String
    let primary: String
    let primaryForeground: String
    let secondary: String
    let secondaryForeground: String
    let secondaryBackground: String
    let muted: String
    let mutedForeground: String
    let border: String
    let destructive: String
    let destructiveForeground: String
    let success: String
    let successForeground: String
    let warning: String
    let warningForeground: String
}

struct ThemeColorScheme: Codable {
    let light: ThemeColors
    let dark: ThemeColors
}

struct ThemeDefinition: Codable {
    let name: String
    let label: String
    let description: String
    let builtin: Bool?
    let colors: ThemeColorScheme?
}

struct ThemesFile: Codable {
    let themes: [ThemeDefinition]
}

func loadThemes(from source: RegistrySource) throws -> [ThemeDefinition] {
    let data: Data
    switch source {
    case .local(let path):
        let url = URL(fileURLWithPath: path).appendingPathComponent("registry/themes.json")
        guard let d = try? Data(contentsOf: url) else {
            print("Error: Could not find registry/themes.json at \(path)")
            print("  Run this from the S0 repo root, or pass --registry-path.")
            throw ExitCode.failure
        }
        data = d
    case .remote(let baseURL):
        let urlString = baseURL + "/registry/themes.json"
        data = try fetchRemote(urlString: urlString, cacheKey: "registry_themes.json")
    }
    guard let themesFile = try? JSONDecoder().decode(ThemesFile.self, from: data) else {
        print("Error: Could not parse registry/themes.json")
        throw ExitCode.failure
    }
    return themesFile.themes
}

// MARK: - Remote Fetch & Cache

func fetchRemote(urlString: String, cacheKey: String) throws -> Data {
    let fm = FileManager.default
    let cachedPath = cacheDir + "/" + cacheKey.replacingOccurrences(of: "/", with: "_")
    
    // Check cache
    if fm.fileExists(atPath: cachedPath),
       let attrs = try? fm.attributesOfItem(atPath: cachedPath),
       let modified = attrs[.modificationDate] as? Date,
       Date().timeIntervalSince(modified) < cacheTTL {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: cachedPath)) {
            return data
        }
    }
    
    // Fetch from network
    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL: \(urlString)")
        throw ExitCode.failure
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    var result: Data?
    var fetchError: Error?
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            fetchError = error
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            fetchError = NSError(domain: "S0", code: httpResponse.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"])
        } else {
            result = data
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    
    if let error = fetchError {
        // Fall back to stale cache if available
        if fm.fileExists(atPath: cachedPath),
           let data = try? Data(contentsOf: URL(fileURLWithPath: cachedPath)) {
            print("⚠ Network error, using cached version: \(error.localizedDescription)")
            return data
        }
        print("Error: Could not fetch \(urlString): \(error.localizedDescription)")
        throw ExitCode.failure
    }
    
    guard let data = result else {
        print("Error: No data received from \(urlString)")
        throw ExitCode.failure
    }
    
    // Write to cache
    try? fm.createDirectory(atPath: cacheDir, withIntermediateDirectories: true)
    try? data.write(to: URL(fileURLWithPath: cachedPath))
    
    return data
}

func fetchComponentFile(filePath: String, source: RegistrySource) throws -> String {
    switch source {
    case .local(let basePath):
        let sourceUrl = URL(fileURLWithPath: basePath).appendingPathComponent(filePath)
        guard let content = try? String(contentsOf: sourceUrl, encoding: .utf8) else {
            print("Error: Could not read source file at \(sourceUrl.path)")
            throw ExitCode.failure
        }
        return content
    case .remote(let baseURL):
        let urlString = baseURL + "/" + filePath
        let data = try fetchRemote(urlString: urlString, cacheKey: filePath)
        guard let content = String(data: data, encoding: .utf8) else {
            print("Error: Could not decode file content from \(urlString)")
            throw ExitCode.failure
        }
        return content
    }
}

// MARK: - Helpers

func resolveOutputPath() -> String {
    let base = FileManager.default.currentDirectoryPath
    if let config = S0Config.load(), let output = config.outputPath {
        return base + "/" + output
    }
    return base + "/S0"
}

// MARK: - Main Command

@main
struct S0CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "s0",
        abstract: "The S0 CLI — A toolkit for SwiftUI components.",
        version: s0Version,
        subcommands: [Init.self, Add.self, Remove.self, Update.self, List.self, Doctor.self, Themes.self],
        defaultSubcommand: Init.self
    )
}

// MARK: - Init

extension S0CLI {
    struct Init: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Initialize S0 in your project."
        )

        @Option(name: .shortAndLong, help: "Theme preset to use (run 's0 themes' to see options).")
        var theme: String?

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let fileManager = FileManager.default
            let s0Path = resolveOutputPath()
            let stylesPath = s0Path + "/Styles"
            let themeName = theme ?? "default"

            print("Creating S0 directory structure...")

            do {
                try fileManager.createDirectory(atPath: stylesPath, withIntermediateDirectories: true)
                
                let themePath = stylesPath + "/S0Theme.swift"
                if !fileManager.fileExists(atPath: themePath) {
                    let content: String
                    if themeName == "default" {
                        content = themeTemplate
                    } else {
                        let source = RegistrySource.resolve(registryPath: registryPath)
                        let themes = try loadThemes(from: source)
                        guard let definition = themes.first(where: { $0.name == themeName }) else {
                            print("Error: Theme '\(themeName)' not found. Run 's0 themes' to see available themes.")
                            throw ExitCode.failure
                        }
                        guard let colors = definition.colors else {
                            print("Error: Theme '\(themeName)' has no color definitions.")
                            throw ExitCode.failure
                        }
                        content = generateThemeTemplate(colors: colors)
                    }
                    try content.write(toFile: themePath, atomically: true, encoding: .utf8)
                    print("✓ Created \(themePath.replacingOccurrences(of: fileManager.currentDirectoryPath + "/", with: "")) (theme: \(themeName))")
                } else {
                    print("! S0Theme.swift already exists, skipping.")
                }

                print("✓ S0 initialized successfully.")
            } catch let error as ExitCode {
                throw error
            } catch {
                print("Error: Could not initialize S0: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

// MARK: - Add

extension S0CLI {
    struct Add: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Add a component to your project."
        )

        @Argument(help: "The name of the component to add.")
        var componentName: String

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let source = RegistrySource.resolve(registryPath: registryPath)
            let registry = try Registry.load(from: source)
            let fileManager = FileManager.default
            
            try addComponent(name: componentName, registry: registry, source: source, fileManager: fileManager)
            
            print("✓ Component '\(componentName)' added successfully.")
        }
        
        private func addComponent(name: String, registry: Registry, source: RegistrySource, fileManager: FileManager) throws {
            guard let component = registry.components.first(where: { $0.name.lowercased() == name.lowercased() }) else {
                print("Error: Component '\(name)' not found in registry.")
                print("  Run 's0 list' to see available components.")
                throw ExitCode.failure
            }
            
            for dependency in component.dependencies {
                try addComponent(name: dependency, registry: registry, source: source, fileManager: fileManager)
            }
            
            let s0Path = resolveOutputPath()
            let uiPath = s0Path + "/UI"
            if !fileManager.fileExists(atPath: uiPath) {
                try fileManager.createDirectory(atPath: uiPath, withIntermediateDirectories: true)
            }
            
            for filePath in component.files {
                let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                let destinationPath = uiPath + "/" + fileName
                
                if fileManager.fileExists(atPath: destinationPath) {
                    print("! \(fileName) already exists, skipping.")
                    continue
                }
                
                let content = try fetchComponentFile(filePath: filePath, source: source)
                try content.write(toFile: destinationPath, atomically: true, encoding: .utf8)
                print("✓ Added \(fileName)")
            }
        }
    }
}

// MARK: - Remove

extension S0CLI {
    struct Remove: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Remove a component from your project."
        )

        @Argument(help: "The name of the component to remove.")
        var componentName: String

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        @Flag(help: "Skip confirmation prompt.")
        var force: Bool = false

        func run() throws {
            let source = RegistrySource.resolve(registryPath: registryPath)
            let registry = try Registry.load(from: source)
            let fileManager = FileManager.default

            guard let component = registry.components.first(where: { $0.name.lowercased() == componentName.lowercased() }) else {
                print("Error: Component '\(componentName)' not found in registry.")
                throw ExitCode.failure
            }
            
            // Check for dependents
            let dependents = registry.components.filter { $0.dependencies.contains(where: { $0.lowercased() == componentName.lowercased() }) }
            if !dependents.isEmpty {
                let names = dependents.map { $0.name }.joined(separator: ", ")
                print("⚠ Warning: The following components depend on '\(componentName)': \(names)")
                if !force {
                    print("  Use --force to remove anyway.")
                    throw ExitCode.failure
                }
            }

            let s0Path = resolveOutputPath()
            let uiPath = s0Path + "/UI"
            var removed = false

            for filePath in component.files {
                let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                let destinationPath = uiPath + "/" + fileName
                
                if fileManager.fileExists(atPath: destinationPath) {
                    try fileManager.removeItem(atPath: destinationPath)
                    print("✓ Removed \(fileName)")
                    removed = true
                } else {
                    print("! \(fileName) not found, skipping.")
                }
            }

            if removed {
                print("✓ Component '\(componentName)' removed.")
            } else {
                print("! Component '\(componentName)' was not installed.")
            }
        }
    }
}

// MARK: - Update

extension S0CLI {
    struct Update: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Update a component from the registry (re-copies the file)."
        )

        @Argument(help: "The name of the component to update.")
        var componentName: String

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let source = RegistrySource.resolve(registryPath: registryPath)
            let registry = try Registry.load(from: source)
            let fileManager = FileManager.default

            guard let component = registry.components.first(where: { $0.name.lowercased() == componentName.lowercased() }) else {
                print("Error: Component '\(componentName)' not found in registry.")
                throw ExitCode.failure
            }

            let s0Path = resolveOutputPath()
            let uiPath = s0Path + "/UI"

            for filePath in component.files {
                let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                let destinationPath = uiPath + "/" + fileName

                let newContent = try fetchComponentFile(filePath: filePath, source: source)
                
                if fileManager.fileExists(atPath: destinationPath) {
                    let existingContent = try? String(contentsOfFile: destinationPath, encoding: .utf8)
                    if existingContent == newContent {
                        print("✓ \(fileName) is already up to date.")
                        continue
                    }
                    try newContent.write(toFile: destinationPath, atomically: true, encoding: .utf8)
                    print("✓ Updated \(fileName)")
                } else {
                    if !fileManager.fileExists(atPath: uiPath) {
                        try fileManager.createDirectory(atPath: uiPath, withIntermediateDirectories: true)
                    }
                    try newContent.write(toFile: destinationPath, atomically: true, encoding: .utf8)
                    print("✓ Added \(fileName) (was not installed)")
                }
            }

            print("✓ Component '\(componentName)' updated.")
        }
    }
}

// MARK: - List

extension S0CLI {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "List all available components in the registry."
        )

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let source = RegistrySource.resolve(registryPath: registryPath)
            let registry = try Registry.load(from: source)

            if registry.components.isEmpty {
                print("No components found in registry.")
                return
            }

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
                    let ver = component.version.map { " (v\($0))" } ?? ""
                    print("    \(component.name)\(ver)\(desc)\(deps)")
                }
                print("")
            }

            print("Add a component with: s0 add <name>")
        }
    }
}

// MARK: - Doctor

extension S0CLI {
    struct Doctor: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Validate your S0 project structure."
        )

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let fileManager = FileManager.default
            let currentPath = fileManager.currentDirectoryPath
            let s0Path = resolveOutputPath()
            var issues = 0

            print("Checking S0 project structure...\n")

            // Check s0.json
            let configPath = currentPath + "/s0.json"
            if fileManager.fileExists(atPath: configPath) {
                print("✓ s0.json found")
                if let config = S0Config.load() {
                    if let rp = config.registryPath { print("  registryPath: \(rp)") }
                    if let op = config.outputPath { print("  outputPath: \(op)") }
                    if let rm = config.remote { print("  remote: \(rm)") }
                } else {
                    print("⚠ s0.json exists but could not be parsed")
                    issues += 1
                }
            } else {
                print("· s0.json not found (optional)")
            }

            // Check S0 directory
            if fileManager.fileExists(atPath: s0Path) {
                print("✓ S0 directory exists at \(s0Path.replacingOccurrences(of: currentPath + "/", with: ""))")
            } else {
                print("✗ S0 directory not found. Run 's0 init' first.")
                issues += 1
            }

            // Check theme file
            let themePath = s0Path + "/Styles/S0Theme.swift"
            if fileManager.fileExists(atPath: themePath) {
                print("✓ S0Theme.swift found")
            } else {
                print("✗ S0Theme.swift not found. Run 's0 init' to create it.")
                issues += 1
            }

            // Check UI directory and installed components
            let uiPath = s0Path + "/UI"
            if fileManager.fileExists(atPath: uiPath) {
                let files = (try? fileManager.contentsOfDirectory(atPath: uiPath))?.filter { $0.hasSuffix(".swift") } ?? []
                print("✓ \(files.count) component(s) installed in S0/UI/")
                
                // Verify against registry
                let source = RegistrySource.resolve(registryPath: registryPath)
                if let registry = try? Registry.load(from: source) {
                    for file in files {
                        let matchesRegistry = registry.components.contains { component in
                            component.files.contains { URL(fileURLWithPath: $0).lastPathComponent == file }
                        }
                        if !matchesRegistry {
                            print("  ⚠ \(file) is not in the registry (custom or outdated)")
                        }
                    }
                }
            } else {
                print("· S0/UI/ not found (no components installed yet)")
            }

            // Registry source
            let source = RegistrySource.resolve(registryPath: registryPath)
            switch source {
            case .local(let path):
                print("· Registry: local (\(path))")
            case .remote(let url):
                print("· Registry: remote (\(url))")
            }

            // Summary
            print("")
            print("· CLI version: \(s0Version)")
            if issues == 0 {
                print("✓ No issues found.")
            } else {
                print("✗ \(issues) issue(s) found.")
            }
        }
    }
}

// MARK: - Themes

extension S0CLI {
    struct Themes: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "List available theme presets."
        )

        @Option(name: .shortAndLong, help: "Local path to the registry (omit to fetch from GitHub).")
        var registryPath: String?

        func run() throws {
            let source = RegistrySource.resolve(registryPath: registryPath)
            let themes = try loadThemes(from: source)

            if themes.isEmpty {
                print("No themes found.")
                return
            }

            print("Available themes:\n")

            let maxNameLength = themes.map { $0.name.count }.max() ?? 0
            for theme in themes {
                let padding = String(repeating: " ", count: max(maxNameLength - theme.name.count + 2, 2))
                print("  \(theme.name)\(padding)\(theme.description)")
            }

            print("\n  \(themes.count) themes available. Use 's0 init --theme <name>' to apply.")
        }
    }
}

// MARK: - Theme Template

private let themeTemplate = """
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
            public static let largeTitle = Font.largeTitle.weight(.bold)
            public static let title = Font.title2.weight(.bold)
            public static let headline = Font.headline
            public static let body = Font.body
            public static let callout = Font.callout
            public static let subheadline = Font.subheadline
            public static let footnote = Font.footnote
            public static let caption = Font.caption
            public static let button = Font.callout.weight(.medium)
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

// MARK: - Hex Theme Template Generator

private func generateThemeTemplate(colors: ThemeColorScheme) -> String {
    let l = colors.light
    let d = colors.dark
    return """
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
            public static let primary = Color.s0Adaptive(light: 0x\(l.primary), dark: 0x\(d.primary))
            public static let primaryForeground = Color.s0Adaptive(light: 0x\(l.primaryForeground), dark: 0x\(d.primaryForeground))
            public static let secondary = Color.s0Adaptive(light: 0x\(l.secondary), dark: 0x\(d.secondary))
            public static let secondaryForeground = Color.s0Adaptive(light: 0x\(l.secondaryForeground), dark: 0x\(d.secondaryForeground))
            public static let secondaryBackground = Color.s0Adaptive(light: 0x\(l.secondaryBackground), dark: 0x\(d.secondaryBackground))
            public static let muted = Color.s0Adaptive(light: 0x\(l.muted), dark: 0x\(d.muted))
            public static let mutedForeground = Color.s0Adaptive(light: 0x\(l.mutedForeground), dark: 0x\(d.mutedForeground))
            public static let border = Color.s0Adaptive(light: 0x\(l.border), dark: 0x\(d.border))
            public static let background = Color.s0Adaptive(light: 0x\(l.background), dark: 0x\(d.background))
            public static let foreground = Color.s0Adaptive(light: 0x\(l.foreground), dark: 0x\(d.foreground))
            public static let card = Color.s0Adaptive(light: 0x\(l.card), dark: 0x\(d.card))
            public static let cardForeground = Color.s0Adaptive(light: 0x\(l.cardForeground), dark: 0x\(d.cardForeground))
            public static let destructive = Color.s0Adaptive(light: 0x\(l.destructive), dark: 0x\(d.destructive))
            public static let destructiveForeground = Color.s0Adaptive(light: 0x\(l.destructiveForeground), dark: 0x\(d.destructiveForeground))
            public static let success = Color.s0Adaptive(light: 0x\(l.success), dark: 0x\(d.success))
            public static let successForeground = Color.s0Adaptive(light: 0x\(l.successForeground), dark: 0x\(d.successForeground))
            public static let warning = Color.s0Adaptive(light: 0x\(l.warning), dark: 0x\(d.warning))
            public static let warningForeground = Color.s0Adaptive(light: 0x\(l.warningForeground), dark: 0x\(d.warningForeground))
        }
        
        // MARK: Typography
        
        public struct Typography {
            public static let largeTitle = Font.largeTitle.weight(.bold)
            public static let title = Font.title2.weight(.bold)
            public static let headline = Font.headline
            public static let body = Font.body
            public static let callout = Font.callout
            public static let subheadline = Font.subheadline
            public static let footnote = Font.footnote
            public static let caption = Font.caption
            public static let button = Font.callout.weight(.medium)
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

// MARK: - Adaptive Color Helper

extension Color {
    static func s0Adaptive(light: UInt, dark: UInt) -> Color {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255.0,
                green: CGFloat((hex >> 8) & 0xFF) / 255.0,
                blue: CGFloat(hex & 0xFF) / 255.0,
                alpha: 1.0
            )
        })
        #elseif canImport(AppKit)
        return Color(nsColor: NSColor(name: nil) { appearance in
            let hex = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
            return NSColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255.0,
                green: CGFloat((hex >> 8) & 0xFF) / 255.0,
                blue: CGFloat(hex & 0xFF) / 255.0,
                alpha: 1.0
            )
        })
        #endif
    }
}
"""
}
