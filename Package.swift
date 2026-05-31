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
        .package(url: "https://github.com/kostub/iosMath", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "PokePhysics",
            dependencies: [
                .product(name: "iosMath", package: "iosMath")
            ],
            path: "Sources/PokePhysics",
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
)
