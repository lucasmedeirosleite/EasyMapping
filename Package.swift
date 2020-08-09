// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "EasyMapping",
    products: [.library(name: "EasyMapping", targets: ["EasyMapping"])],
    targets: [
        .target(name: "EasyMapping", exclude: ["Sources/EasyMapping+XCTestCase"])
    ]
)
