import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Scene",
    targets: [
        .make(
            name: "Home",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.home",
            sources: ["HomeScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem
            ]
        ),
        .make(
            name: "Splash",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.splash",
            sources: ["SplashScene/**"],
            dependencies: [
                .spm(.composableArchitecture)
            ]
        ),
        .make(
            name: "StorageBox",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.storageBox",
            sources: ["StorageBoxScene/**"],
            dependencies: [
                .spm(.composableArchitecture)
            ]
        ),
        .make(
            name: "Web",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.web",
            sources: ["WebScene/**"],
            dependencies: [
                .spm(.composableArchitecture)
            ]
        ),
        .make(
            name: "SaveURL",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.saveURL",
            sources: ["SaveURLScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem
            ]
        ),
        .make(
            name: "CreateNewFolder",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.createNewFolder",
            sources: ["CreateNewFolderScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem
            ]
        )
    ]
)
