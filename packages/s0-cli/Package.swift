// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "s0-cli",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "s0", targets: ["s0"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "s0",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
