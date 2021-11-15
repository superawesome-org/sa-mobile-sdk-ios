// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SuperAwesome",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "SuperAwesome",
            targets: ["SuperAwesome"])
    ],
    dependencies: [
        .package(name: "Nimble",
                 url: "https://github.com/Quick/Nimble.git",
                 .upToNextMajor(from: "9.2.1"))
    ],
    targets: [
        .target(
            name: "SuperAwesome",
            dependencies: ["SUPMoatMobileAppKit-Target"],
            path: "Pod/Sources"
        ),
        .binaryTarget(
            name: "SUPMoatMobileAppKit-Target",
            path: "Pod/Libraries/SUPMoatMobileAppKit.xcframework"
        ),
        
        .testTarget(
            name: "sa-mobile-sdk-iosTests",
            dependencies: ["SuperAwesome", "Nimble"],
            path: "Pod/Tests",
            resources: [.copy("Resources/fixtures_tests.bundle")]
        ),
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
