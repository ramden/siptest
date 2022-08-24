// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "PJSIP",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library( name: "PJSIP", targets: ["PJSIP"]),
    ],
    targets: [
        .binaryTarget(name: "libpjproject", path: "libpjproject.xcframework"),
        .systemLibrary(name: "Cpjproject", pkgConfig: "pjproject-apple-platforms-SPM"),
        .target(name: "PJSUA2Wrapper", dependencies: ["libpjproject","Cpjproject"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
        .target( name: "PJSIP", dependencies: ["PJSUA2Wrapper"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
        .testTarget( name: "PJSIPTests", dependencies: ["PJSIP"], cxxSettings: [
            .define("PJ_AUTOCONF")
        ]),
    ],
    cxxLanguageStandard: .cxx17
)
