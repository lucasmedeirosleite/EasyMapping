import PackageDescription

let library  = [
    Target(name: "EasyMapping")
    // Target(name: "EasyMapping+XCTestCase", dependencies: [ .Target(name: "EasyMapping")])
]

let package = Package(
    name: "EasyMapping",
    targets: library,
    exclude: ["Sources/EasyMapping+XCTestCase"]
)
