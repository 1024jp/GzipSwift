// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Gzip",
    products: [
        .library(name: "Gzip", targets: ["Gzip"]),
    ],
    targets: [
        .target(name: "Gzip",
                dependencies: ["system-zlib"],
                swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(name: "system-zlib"),
        .testTarget(
            name: "GzipTests",
            dependencies: ["Gzip"],
            resources: [.copy("./test.txt.gz")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
    ]
)
