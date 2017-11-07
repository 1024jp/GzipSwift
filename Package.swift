// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Gzip",
    products: [
      .library(name: "Gzip", targets: ["Gzip"])
    ],
    dependencies: [],
    targets: [
      .target(name: "Gzip", dependencies: ["zlib"]),
      .target(name: "zlib"),
      .testTarget(name: "GzipTests", dependencies: ["Gzip"])
    ]
)
