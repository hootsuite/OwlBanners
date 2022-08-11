// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OwlBanners",
    products: [
        .library(name: "OwlBanners", targets: ["OwlBanners"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "OwlBanners", path: "Sources/OwlBanners", resources: [.process("Resources")]),
    ]
)
