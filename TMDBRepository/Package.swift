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
            name: "TMDBRepositoryImpl",
            targets: ["TMDBRepositoryImpl"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking"),
    ],
    targets: [
        .target(
            name: "TMDBRepository"
        ),
        .target(
            name: "TMDBRepositoryImpl",
            dependencies: ["TMDBRepository", "Networking"]
        ),
        .testTarget(
            name: "TMDBRepositoryTests",
            dependencies: ["TMDBRepositoryImpl"]
        ),
    ]
)
