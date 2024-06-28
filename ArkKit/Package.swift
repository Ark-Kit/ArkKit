// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArkKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ArkKit",
            targets: ["ArkKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
        .package(url: "https://github.com/dobster/P2PShareKit", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "ArkKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "P2PShare", package: "P2PShareKit")
            ]
        ),
        .testTarget(
            name: "ArkKitTests",
            dependencies: ["ArkKit"]
        )
    ]
)
