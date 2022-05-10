// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-pipe",
    platforms: [.iOS(.v13), .macOS(.v10_15), .macCatalyst(.v13)],
    products: [
        .library(
            name: "Pipe",
            targets: ["Pipe"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Pipe",
            dependencies: []),
        .testTarget(
            name: "PipeTests",
            dependencies: ["Pipe"]),
    ]
)
