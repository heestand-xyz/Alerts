// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Alerts",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
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
