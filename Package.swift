// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "KeychainItem",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "KeychainItem", targets: ["KeychainItem"]),
    ],
    targets: [
        .target(name: "KeychainItem"),
        .testTarget(name: "KeychainItemTests", dependencies: ["KeychainItem"]),
    ]
)
