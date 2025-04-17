// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizationKitSwiftUI",
    products: [
        .library(
            name: "LocalizationKitSwiftUI",
            targets: ["LocalizationKitSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.4.3")
    ],
    targets: [
        .target(
            name: "LocalizationKitSwiftUI",
            dependencies: [
                .product(name: "Factory", package: "Factory"),
            ],
        ),
        .testTarget(
            name: "LocalizationKitSwiftUITests",
            dependencies: ["LocalizationKitSwiftUI"]
        ),
    ]
)
