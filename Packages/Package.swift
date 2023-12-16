// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let composable = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
private let dependencies = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
private let dependenciesMacros = Target.Dependency.product(name: "DependenciesMacros", package: "swift-dependencies")
private let tagged = Target.Dependency.product(name: "Tagged", package: "swift-tagged")
private let testOverlay = Target.Dependency.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")

private let withConcurrencyFlags = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("StrictConcurrency"),
    SwiftSetting.unsafeFlags(
        [
            "-Xfrontend",
            "-warn-long-function-bodies=100",
            "-Xfrontend",
            "-warn-long-expression-type-checking=100",
            "-Xfrontend",
            "-warn-concurrency",
            "-Xfrontend",
            "-enable-actor-data-race-checks"
        ]
    )
]

let package = Package(
    name: "Packages",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "ApplicationPackages",
            targets: [
                "AlchemyAPIClientLive",
                "ApplicationFeature",
                "NetworkClientLive",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.5.5"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", exact: "1.0.2"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", exact: "0.10.0"),
    ],
    targets: [
        .target(
            name: "AlchemyAPIClient",
            dependencies: [
                "DataModel",
                
                dependencies,
                dependenciesMacros,
                testOverlay
            ]
        ),
        .target(
            name: "AlchemyAPIClientLive",
            dependencies: [
                "AlchemyAPIClient",
                "NetworkClient"
            ]
        ),
        .target(
            name: "ApplicationFeature",
            dependencies: [
                "AlchemyAPIClient",
                "DataModel",
                "ItemDetailsFeature",
                "ItemSummaryFeature",
                
                composable
            ]
        ),
        .target(
            name: "DataModel",
            dependencies: [
                tagged
            ]
        ),
        .target(
            name: "ItemDetailsFeature",
            dependencies: [
                "DataModel",
                
                composable
            ]
        ),
        .target(
            name: "ItemSummaryFeature",
            dependencies: [
                "DataModel"
            ]
        ),
        .target(
            name: "NetworkClient",
            dependencies: [
                "DataModel",
                
                dependencies,
                dependenciesMacros,
                testOverlay
            ]
        ),
        .target(
            name: "NetworkClientLive",
            dependencies: ["NetworkClient"]
        ),
        
        .testTarget(
            name: "ApplicationFeatureTests",
            dependencies: [
                "ApplicationFeature"
            ]
        )
    ]
    .map { (target: Target) in
        guard target.swiftSettings == nil else {
            return target
        }
        
        target.swiftSettings = withConcurrencyFlags
        return target
    }
)
