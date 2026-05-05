// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "GzipSwift",
    products: [
        .library(name: "Gzip", targets: ["Gzip"]),
    ],
    targets: [
        .target(name: "Gzip"),
        .testTarget(
            name: "GzipTests",
            dependencies: ["Gzip"],
            resources: [.copy("test.txt.gz")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

#if os(Linux)
package.targets.append(
    .systemLibrary(
        name: "system-zlib",
        pkgConfig: "zlib",
        providers: [
            .apt(["zlib1g-dev"]),
        ]
    )
)
package.targets.first { $0.name == "Gzip" }!.dependencies.append(.target(name: "system-zlib"))
#endif


for target in package.targets where target.name != "system-zlib" {
    target.swiftSettings = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
