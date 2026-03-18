import XCTest
import Foundation

/// Integration tests for the S0 CLI.
/// Runs the compiled binary in temp directories to verify real behavior.
final class CLIIntegrationTests: XCTestCase {
    
    private var tmpDir: URL!
    private var binaryURL: URL!
    private var registryDir: URL!
    
    override func setUp() {
        super.setUp()
        tmpDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("s0-test-\(UUID().uuidString)")
        try! FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        
        // The binary is built at a known path relative to the package
        // swift build puts it in .build/debug/s0
        let packageDir = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // s0Tests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // s0-cli
        binaryURL = packageDir.appendingPathComponent(".build/debug/s0")
        
        // Registry is at repo root
        registryDir = packageDir
            .deletingLastPathComponent() // packages
            .deletingLastPathComponent() // s0 repo root
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: tmpDir)
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    @discardableResult
    private func run(_ args: [String], workDir: URL? = nil) throws -> (stdout: String, stderr: String, exitCode: Int32) {
        let process = Process()
        process.executableURL = binaryURL
        process.arguments = args
        process.currentDirectoryURL = workDir ?? tmpDir
        
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        
        try process.run()
        process.waitUntilExit()
        
        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        
        return (
            stdout: String(data: stdoutData, encoding: .utf8) ?? "",
            stderr: String(data: stderrData, encoding: .utf8) ?? "",
            exitCode: process.terminationStatus
        )
    }
    
    private func fileExists(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: tmpDir.appendingPathComponent(path).path)
    }
    
    private func readFile(_ path: String) throws -> String {
        try String(contentsOf: tmpDir.appendingPathComponent(path), encoding: .utf8)
    }
    
    // MARK: - Init Tests
    
    func testInitCreatesDirectoryStructure() throws {
        let result = try run(["init"])
        
        XCTAssertEqual(result.exitCode, 0, "Exit code should be 0")
        XCTAssertTrue(result.stdout.contains("S0 initialized successfully"), "Should print success message")
        XCTAssertTrue(fileExists("S0/Styles/S0Theme.swift"), "Should create S0Theme.swift")
    }
    
    func testInitThemeContainsNamespace() throws {
        try run(["init"])
        
        let theme = try readFile("S0/Styles/S0Theme.swift")
        XCTAssertTrue(theme.contains("public enum S0"), "Theme should define S0 namespace")
        XCTAssertTrue(theme.contains("struct Theme"), "Theme should contain Theme struct")
        XCTAssertTrue(theme.contains("struct Colors"), "Theme should contain Colors")
        XCTAssertTrue(theme.contains("struct Spacing"), "Theme should contain Spacing")
        XCTAssertTrue(theme.contains("struct Typography"), "Theme should contain Typography")
    }
    
    func testInitSkipsExistingTheme() throws {
        // First init
        try run(["init"])
        // Modify the theme file
        let themePath = tmpDir.appendingPathComponent("S0/Styles/S0Theme.swift")
        try "custom content".write(to: themePath, atomically: true, encoding: .utf8)
        
        // Second init
        let result = try run(["init"])
        XCTAssertTrue(result.stdout.contains("already exists, skipping"), "Should skip existing theme")
        
        // Verify content wasn't overwritten
        let content = try String(contentsOf: themePath, encoding: .utf8)
        XCTAssertEqual(content, "custom content", "Should not overwrite existing theme")
    }
    
    func testInitIdempotent() throws {
        try run(["init"])
        let result = try run(["init"])
        
        XCTAssertEqual(result.exitCode, 0, "Second init should succeed")
    }
    
    // MARK: - Add Tests
    
    func testAddComponent() throws {
        try run(["init"])
        let result = try run(["add", "button", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Added Button.swift"))
        XCTAssertTrue(result.stdout.contains("'button' added successfully"))
        XCTAssertTrue(fileExists("S0/UI/Button.swift"), "Should copy Button.swift")
    }
    
    func testAddComponentCopiesCorrectContent() throws {
        try run(["init"])
        try run(["add", "badge", "-r", registryDir.path])
        
        let installed = try readFile("S0/UI/Badge.swift")
        let source = try String(contentsOf: registryDir.appendingPathComponent("registry/ui/Badge.swift"), encoding: .utf8)
        XCTAssertEqual(installed, source, "Installed file should match registry source")
    }
    
    func testAddWithDependency() throws {
        // Accordion depends on separator
        try run(["init"])
        let result = try run(["add", "accordion", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(fileExists("S0/UI/Accordion.swift"), "Should install accordion")
        XCTAssertTrue(fileExists("S0/UI/Separator.swift"), "Should auto-install dependency")
    }
    
    func testAddSkipsExistingComponent() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        
        let result = try run(["add", "button", "-r", registryDir.path])
        XCTAssertTrue(result.stdout.contains("already exists, skipping"), "Should skip existing file")
    }
    
    func testAddUnknownComponent() throws {
        try run(["init"])
        let result = try run(["add", "nonexistent", "-r", registryDir.path])
        
        XCTAssertNotEqual(result.exitCode, 0, "Should fail for unknown component")
        XCTAssertTrue(result.stdout.contains("not found in registry"))
    }
    
    func testAddCaseInsensitive() throws {
        try run(["init"])
        let result = try run(["add", "Button", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(fileExists("S0/UI/Button.swift"))
    }
    
    // MARK: - Remove Tests
    
    func testRemoveComponent() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        XCTAssertTrue(fileExists("S0/UI/Button.swift"))
        
        let result = try run(["remove", "button", "-r", registryDir.path, "--force"])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Removed Button.swift"))
        XCTAssertFalse(fileExists("S0/UI/Button.swift"), "File should be removed")
    }
    
    func testRemoveNotInstalled() throws {
        try run(["init"])
        let result = try run(["remove", "button", "-r", registryDir.path, "--force"])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("not found, skipping") || result.stdout.contains("was not installed"))
    }
    
    func testRemoveWithDependentsWarns() throws {
        // Install accordion (depends on separator) then try to remove separator
        try run(["init"])
        try run(["add", "accordion", "-r", registryDir.path])
        
        let result = try run(["remove", "separator", "-r", registryDir.path])
        
        XCTAssertNotEqual(result.exitCode, 0, "Should fail without --force")
        XCTAssertTrue(result.stdout.contains("Warning"), "Should warn about dependents")
        XCTAssertTrue(result.stdout.contains("accordion"), "Should mention the dependent component")
        XCTAssertTrue(fileExists("S0/UI/Separator.swift"), "Should NOT remove the file")
    }
    
    func testRemoveWithDependentsForce() throws {
        try run(["init"])
        try run(["add", "accordion", "-r", registryDir.path])
        
        let result = try run(["remove", "separator", "-r", registryDir.path, "--force"])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertFalse(fileExists("S0/UI/Separator.swift"), "Should remove with --force")
    }
    
    func testRemoveUnknownComponent() throws {
        try run(["init"])
        let result = try run(["remove", "nonexistent", "-r", registryDir.path])
        
        XCTAssertNotEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("not found in registry"))
    }
    
    // MARK: - Update Tests
    
    func testUpdateReplacesModifiedFile() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        
        // Modify the installed file
        let filePath = tmpDir.appendingPathComponent("S0/UI/Button.swift")
        try "modified content".write(to: filePath, atomically: true, encoding: .utf8)
        
        let result = try run(["update", "button", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Updated Button.swift"))
        
        // Verify content was restored
        let content = try String(contentsOf: filePath, encoding: .utf8)
        let source = try String(contentsOf: registryDir.appendingPathComponent("registry/ui/Button.swift"), encoding: .utf8)
        XCTAssertEqual(content, source, "File should be restored from registry")
    }
    
    func testUpdateSkipsUnchangedFile() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        
        let result = try run(["update", "button", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("already up to date"))
    }
    
    func testUpdateInstallsIfMissing() throws {
        try run(["init"])
        // Don't add button first — update should install it
        let result = try run(["update", "button", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("was not installed") || result.stdout.contains("Added"))
        XCTAssertTrue(fileExists("S0/UI/Button.swift"))
    }
    
    func testUpdateUnknownComponent() throws {
        try run(["init"])
        let result = try run(["update", "nonexistent", "-r", registryDir.path])
        
        XCTAssertNotEqual(result.exitCode, 0)
    }
    
    // MARK: - List Tests
    
    func testListShowsAllComponents() throws {
        let result = try run(["list", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Available components (24)"))
        XCTAssertTrue(result.stdout.contains("button"))
        XCTAssertTrue(result.stdout.contains("card"))
        XCTAssertTrue(result.stdout.contains("input"))
    }
    
    func testListShowsCategories() throws {
        let result = try run(["list", "-r", registryDir.path])
        
        XCTAssertTrue(result.stdout.contains("primitives"))
        XCTAssertTrue(result.stdout.contains("forms"))
        XCTAssertTrue(result.stdout.contains("layout"))
    }
    
    func testListShowsDependencies() throws {
        let result = try run(["list", "-r", registryDir.path])
        
        XCTAssertTrue(result.stdout.contains("[requires: separator]"), "Should show accordion's dependency")
    }
    
    func testListShowsVersions() throws {
        let result = try run(["list", "-r", registryDir.path])
        
        XCTAssertTrue(result.stdout.contains("(v1.0.0)"), "Should show component version")
    }
    
    func testListWithBadRegistry() throws {
        let result = try run(["list", "-r", "/nonexistent/path"])
        
        XCTAssertNotEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Could not find registry.json"))
    }
    
    // MARK: - Doctor Tests
    
    func testDoctorCleanProject() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        
        let result = try run(["doctor", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("S0 directory exists"))
        XCTAssertTrue(result.stdout.contains("S0Theme.swift found"))
        XCTAssertTrue(result.stdout.contains("1 component(s) installed"))
        XCTAssertTrue(result.stdout.contains("No issues found"))
    }
    
    func testDoctorUninitializedProject() throws {
        let result = try run(["doctor", "-r", registryDir.path])
        
        XCTAssertEqual(result.exitCode, 0)  // doctor reports but doesn't fail
        XCTAssertTrue(result.stdout.contains("S0 directory not found"))
        XCTAssertTrue(result.stdout.contains("S0Theme.swift not found"))
        XCTAssertTrue(result.stdout.contains("issue(s) found"))
    }
    
    func testDoctorWithConfig() throws {
        // Create a s0.json config
        let config = """
        {
            "registryPath": "./my-registry",
            "outputPath": "./Sources/S0"
        }
        """
        try config.write(to: tmpDir.appendingPathComponent("s0.json"), atomically: true, encoding: .utf8)
        
        let result = try run(["doctor", "-r", registryDir.path])
        
        XCTAssertTrue(result.stdout.contains("s0.json found"))
        XCTAssertTrue(result.stdout.contains("registryPath"))
    }
    
    // MARK: - Help Tests
    
    func testHelpShowsAllCommands() throws {
        let result = try run(["--help"])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("init"))
        XCTAssertTrue(result.stdout.contains("add"))
        XCTAssertTrue(result.stdout.contains("remove"))
        XCTAssertTrue(result.stdout.contains("update"))
        XCTAssertTrue(result.stdout.contains("list"))
        XCTAssertTrue(result.stdout.contains("doctor"))
    }
    
    // MARK: - Edge Cases
    
    func testAddMultipleComponents() throws {
        try run(["init"])
        try run(["add", "button", "-r", registryDir.path])
        try run(["add", "card", "-r", registryDir.path])
        try run(["add", "badge", "-r", registryDir.path])
        
        XCTAssertTrue(fileExists("S0/UI/Button.swift"))
        XCTAssertTrue(fileExists("S0/UI/Card.swift"))
        XCTAssertTrue(fileExists("S0/UI/Badge.swift"))
        
        let doctor = try run(["doctor", "-r", registryDir.path])
        XCTAssertTrue(doctor.stdout.contains("3 component(s) installed"))
    }
    
    func testCorruptRegistryJSON() throws {
        // Create a temp dir with a corrupt registry.json
        let corruptDir = tmpDir.appendingPathComponent("corrupt-registry")
        try FileManager.default.createDirectory(at: corruptDir, withIntermediateDirectories: true)
        try "{ invalid json".write(to: corruptDir.appendingPathComponent("registry.json"), atomically: true, encoding: .utf8)
        
        let result = try run(["list", "-r", corruptDir.path])
        
        XCTAssertNotEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("Could not parse registry.json"))
    }
    
    func testEmptyRegistry() throws {
        let emptyDir = tmpDir.appendingPathComponent("empty-registry")
        try FileManager.default.createDirectory(at: emptyDir, withIntermediateDirectories: true)
        let emptyRegistry = """
        {"components": []}
        """
        try emptyRegistry.write(to: emptyDir.appendingPathComponent("registry.json"), atomically: true, encoding: .utf8)
        
        let result = try run(["list", "-r", emptyDir.path])
        
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertTrue(result.stdout.contains("No components found"))
    }
}
