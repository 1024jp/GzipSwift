// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "Gzip",
    products: [
        .library(name: "Gzip", targets: ["Gzip"]),
    ],
    targets: [
        .target(name: "Gzip", dependencies: ["system-zlib"]),
        .target(name: "system-zlib"),
        .testTarget(
            name: "GzipTests",
            dependencies: ["Gzip"],
            resources: [.copy("./test.txt.gz")]
        ),
    ]
)
