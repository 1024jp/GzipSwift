// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GzipSwift",
    products: [
        .library(name: "Gzip", targets: ["Gzip"]),
    ],
    targets: [
        .target(
            name: "Gzip",
            dependencies: ["system-zlib"]
        ),
        .target(
            name: "system-zlib"
        ),
        .testTarget(
            name: "GzipTests",
            dependencies: ["Gzip"],
            resources: [.copy("test.txt.gz")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
