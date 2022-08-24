// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "PJSIP",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "PJSUA2", targets: ["PJSUA2"]),
        .library(name: "PJSUA", targets: ["PJSUA"])
    ],
    targets: [
        .binaryTarget(name: "libpjproject", path: "libpjproject.xcframework"),
        .systemLibrary(name: "Cpjproject", pkgConfig: "pjproject-apple-platforms-SPM"),
        .target(name: "PJSUA2Wrapper", dependencies: ["libpjproject","Cpjproject"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
        .target( name: "PJSUA2", dependencies: ["PJSUA2Wrapper"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
        .testTarget( name: "PJSUA2Tests", dependencies: ["PJSUA2"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
        .target(name: "PJSUA", dependencies: ["Cpjproject"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ])
    ],
    cxxLanguageStandard: .cxx17
)
