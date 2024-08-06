import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        .make(
            name: "Common",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.common",
            sources: ["Common/**"],
            dependencies: [.localizationKit]
        ),
        .make(
            name: "Models",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.models",
            sources: ["Models/**"],
            dependencies: [.localizationKit]
        ),
        .make(
            name: "Services",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.services",
            sources: ["Services/**"],
            dependencies: [
                .spm(.alamofire),
                .spm(.composableArchitecture),
                .spm(.keychainAccess),
                .core(.model)
            ]
        )
    ]
)
