// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Raylib_Swiftness",
    dependencies: [
        .package(url: "https://github.com/Magd74NA/Raylib_Swiftness", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Swiftness",
            dependencies: [
                .product(name: "Raylib", package: "Raylib_Swiftness") // Corrected product name
            ]
        )
    ]
)
