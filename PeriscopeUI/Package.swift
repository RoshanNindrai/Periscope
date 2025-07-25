// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PeriscopeUI",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PeriscopeUI",
            targets: ["PeriscopeUI"]
        ),
    ],
    dependencies: [
        .package(path: "../DataModel"),
        .package(path: "../Lego"),
        .package(path: "../Routes"),
        .package(path: "../TMDBRepository")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PeriscopeUI",
            dependencies: ["Lego", "DataModel", "Routes", "TMDBRepository"]
        ),

    ]
)
