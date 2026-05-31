// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PokePhysics",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "PokePhysics", targets: ["PokePhysics"])
    ],
    dependencies: [
        .package(url: "https://github.com/kostub/iosMath", from: "0.9.5")
    ],
    targets: [
        .target(
            name: "PokePhysics",
            dependencies: [
                .product(name: "iosMath", package: "iosMath")
            ],
            path: "Sources/PokePhysics"
        )
    ]
)
