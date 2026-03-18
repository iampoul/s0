// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "S0-Showcase",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "S0ShowcaseLib", targets: ["S0ShowcaseLib"]),
        .executable(name: "S0-Showcase", targets: ["S0-Showcase"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "S0ShowcaseLib",
            dependencies: [],
            path: "Sources/S0ShowcaseLib"
        ),
        .executableTarget(
            name: "S0-Showcase",
            dependencies: ["S0ShowcaseLib"],
            path: "Sources/S0-Showcase"
        ),
    ]
)
