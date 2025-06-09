// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Stadiumly",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Stadiumly",
            targets: ["Stadiumly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jonkykong/SideMenu.git", from: "6.5.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.3.2"),
        .package(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM", from: "2.12.5"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
        .package(url: "https://github.com/AssistoLab/DropDown.git", from: "2.3.13"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "Stadiumly",
            dependencies: [
                "SideMenu",
                "SnapKit",
                "Kingfisher",
                .product(name: "KakaoMapsSDK-SPM", package: "KakaoMapsSDK-SPM"),
                "Alamofire",
                "DropDown",
                "KeychainAccess"
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "KakaoMapsSDK",
            url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM/releases/download/2.12.5/KakaoMapsSDK.xcframework.zip",
            checksum: "e96e3e57f3c1f0f1e0c0d59c9f63b8c4d4c4d4c4d4c4d4c4d4c4d4c4d4c4d4c"
        )
    ]
) 