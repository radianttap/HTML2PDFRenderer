// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "HTML2PDFRenderer",
    products: [
        .library(name: "HTML2PDFRenderer", targets: ["HTML2PDFRenderer"])
    ],
    targets: [
        .target(name: "HTML2PDFRenderer")
    ],
    swiftLanguageVersions: [.v5]
)
