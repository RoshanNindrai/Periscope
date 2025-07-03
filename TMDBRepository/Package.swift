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
        .library(
            name: "TMDBService",
            targets: ["TMDBService"]
        ),
    ],
    dependencies: [
        .package(path: "../DataModel"),
        .package(path: "../Networking"),
        .package(path: "../Utils"),
    ],
    targets: [
        .target(
            name: "TMDBRepository",
            dependencies: ["DataModel", "Networking", "TMDBService", "Utils"]
        ),
        .target(
            name: "TMDBRepositoryImpl",
            dependencies: ["DataModel", "TMDBRepository", "TMDBService", "Networking", "Utils"]
        ),
        .target(
            name: "TMDBRepositoryFactory",
            dependencies: ["TMDBRepository", "Networking", "TMDBRepositoryImpl", "Utils"]
        ),
        .target(
            name: "TMDBService",
            dependencies: ["DataModel"]
        ),
        .testTarget(
            name: "TMDBRepositoryTests",
            dependencies: ["TMDBRepositoryImpl"]
        ),
    ]
)
