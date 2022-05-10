// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "swift-channel",
    platforms: [.iOS(.v13), .macOS(.v10_15), .macCatalyst(.v13)],
    products: [
        .library(name: "Channel", targets: [
            "Channel",
        ]),
        .executable(name: "channel-example", targets: [
            "ChannelExample",
        ]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Channel", dependencies: [
        ]),
        .testTarget(name: "ChannelTests", dependencies: [
            "Channel",
        ]),
        
        .executableTarget(name: "ChannelExample", dependencies: [
            .target(name: "Channel"),
        ]),
    ]
)
