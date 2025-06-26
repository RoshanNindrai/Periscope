// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMDBRepository",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "TMDBRepository",
            targets: ["TMDBRepository"]
        ),
        .library(
            name: "TMDBRepositoryFactory",
            targets: ["TMDBRepositoryFactory"]
        ),
        .library(
            name: "TMDBRepositoryImpl",
            targets: ["TMDBRepositoryImpl"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../Utils"),
    ],
    targets: [
        .target(
            name: "TMDBRepository",
            dependencies: ["Networking"]
        ),
        .target(
            name: "TMDBRepositoryImpl",
            dependencies: ["TMDBRepository", "Networking", "Utils"]
        ),
        .target(
            name: "TMDBRepositoryFactory",
            dependencies: ["TMDBRepository", "Networking", "TMDBRepositoryImpl", "Utils"]
        ),
        .testTarget(
            name: "TMDBRepositoryTests",
            dependencies: ["TMDBRepositoryImpl"]
        ),
    ]
)
