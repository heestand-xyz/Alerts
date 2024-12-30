// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Alerts",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Alerts",
            targets: ["Alerts"]),
    ],
    targets: [
        .target(
            name: "Alerts",
            dependencies: []),
    ]
)
