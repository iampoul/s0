// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "S0-Showcase",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "S0-Showcase", targets: ["S0-Showcase"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "S0-Showcase",
            dependencies: [],
            path: "Sources/S0-Showcase"
        ),
    ]
)
