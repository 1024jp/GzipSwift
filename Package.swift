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
                // Conditioned on the *target* platform (not the host), so this also
                // works when cross-compiling, e.g. with the static Linux (musl) SDK.
                .target(name: "system-zlib", condition: .when(platforms: [.linux])),
            ]
        ),
        .systemLibrary(
            name: "system-zlib",
            providers: [
                .apt(["zlib1g-dev"]),
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
