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
        .package(url: "https://github.com/kostub/iosMath", branch: "master"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "11.0.0")
    ],
    targets: [
        .target(
            name: "PokePhysics",
            dependencies: [
                .product(name: "iosMath", package: "iosMath"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Sources/PokePhysics"
        )
    ]
)
