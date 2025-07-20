// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppSetup",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppSetup",
            targets: ["AppSetup"]
        ),
    ],

    dependencies: [
        .package(path: "../TMDBRepository"),
        .package(path: "../Networking"),
        .package(path: "../Utils"),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppSetup",
            dependencies: [
                "Networking",
                .product(name: "NetworkingFactory", package: "Networking"),
                "TMDBRepository",
                .product(name: "TMDBRepositoryFactory", package: "TMDBRepository"),
                "Utils",
                .product(name: "UtilsFactory", package: "Utils")
            ]
        ),
    ]
)
