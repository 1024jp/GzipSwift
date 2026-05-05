// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "GzipSwift",
    products: [
        .library(name: "Gzip", targets: ["Gzip"]),
    ],
    targets: [
        .target(
            name: "Gzip",
            dependencies: [
                .target(name: "system-zlib", condition: .when(platforms: [.linux])),
            ]
        ),
        .systemLibrary(
            name: "system-zlib",
            path: "Sources/system-zlib",
            pkgConfig: "zlib",
            providers: [
                .apt(["zlib1g-dev"]),
                .brew(["zlib"]),
            ]
        ),
        .testTarget(
            name: "GzipTests",
            dependencies: ["Gzip"],
            resources: [.copy("test.txt.gz")]
        ),
    ],
    swiftLanguageModes: [.v6]
)


for target in package.targets where target.name != "system-zlib" {
    target.swiftSettings = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
