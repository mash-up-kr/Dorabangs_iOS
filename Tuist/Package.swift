// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "ACarousel": .framework,
            "Alamofire": .framework,
            "ComposableArchitecture": .framework,
            "TCACoordinators": .framework
        ]
    )
#endif

let package = Package(
    name: "Dorabangs",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.11.0"),
        .package(url: "https://github.com/johnpatrickmorgan/TCACoordinators", exact: "0.10.1"),
        .package(url: "https://github.com/Alamofire/Alamofire", exact: "5.9.1"),
        .package(url: "https://github.com/JWAutumn/ACarousel", exact: "0.2.0")
    ]
)
