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
                .core(.common),
                .core(.model),
                .core(.service),
                .spm(.acarousel),
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
                .core(.service),
                .spm(.composableArchitecture),
                .designSystem
            ]
        ),
        .make(
            name: "StorageBox",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.storageBox",
            sources: ["StorageBoxScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.model)
            ]
        ),
        .make(
            name: "Feed",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.feed",
            sources: ["FeedScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.model)
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
                .designSystem,
                .core(.service),
                .core(.model)
            ]
        ),
        .make(
            name: "SelectFolder",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.selectFolder",
            sources: ["SelectFolderScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.service),
                .core(.model)
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
        ),
        .make(
            name: "Onboarding",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.Onboarding",
            sources: ["OnboardingScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .core(.service),
                .designSystem
            ]
        ),
        .make(
            name: "ChangeFolderName",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.changeFolderName",
            sources: ["ChangeFolderNameScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem
            ]
        ),
        .make(
            name: "AIClassification",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.aiClassification",
            sources: ["AIClassificationScene/**"],
            dependencies: [
                .core(.model),
                .spm(.composableArchitecture),
                .designSystem
            ]
        )
    ]
)
