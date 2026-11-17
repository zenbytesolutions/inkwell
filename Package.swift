// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Inkwell",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [.library(name: "Inkwell", targets: ["Inkwell"])],
    targets: [.target(name: "Inkwell", path: "swift/Sources/Inkwell")]
)
