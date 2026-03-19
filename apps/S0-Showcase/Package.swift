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
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0"),
    ],
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
        .testTarget(
            name: "S0SnapshotTests",
            dependencies: [
                "S0ShowcaseLib",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            path: "Tests/S0SnapshotTests"
        ),
    ]
)
