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
                .spm(.lottie),
                .spm(.kingfisher),
                .designSystem,
                .localizationKit
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
                .spm(.lottie),
                .designSystem
            ]
        ),
        .make(
            name: "StorageBox",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.storageBox",
            sources: ["StorageBoxScene/**"],
            dependencies: [
                .core(.service),
                .spm(.composableArchitecture),
                .designSystem,
                .core(.model),
                .localizationKit
            ]
        ),
        .make(
            name: "Feed",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.feed",
            sources: ["FeedScene/**"],
            dependencies: [
                .core(.service),
                .spm(.composableArchitecture),
                .spm(.kingfisher),
                .designSystem,
                .core(.model),
                .localizationKit
            ]
        ),
        .make(
            name: "Web",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.web",
            sources: ["WebScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .localizationKit
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
                .core(.common),
                .core(.service),
                .core(.model),
                .localizationKit
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
                .core(.common),
                .core(.service),
                .core(.model),
                .localizationKit
            ]
        ),
        .make(
            name: "CreateNewFolder",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.createNewFolder",
            sources: ["CreateNewFolderScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.service),
                .core(.model),
                .localizationKit
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
                .designSystem,
                .localizationKit
            ]
        ),
        .make(
            name: "ChangeFolderName",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.changeFolderName",
            sources: ["ChangeFolderNameScene/**"],
            dependencies: [
                .core(.service),
                .core(.model),
                .spm(.composableArchitecture),
                .designSystem,
                .localizationKit
            ]
        ),
        .make(
            name: "AIClassification",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.aiClassification",
            sources: ["AIClassificationScene/**"],
            dependencies: [
                .core(.common),
                .core(.model),
                .core(.service),
                .spm(.composableArchitecture),
                .spm(.kingfisher),
                .designSystem,
                .localizationKit
            ]
        ),
        .make(
            name: "SaveURLVideoGuide",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.saveURLVideoGuide",
            sources: ["SaveURLVideoGuideScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .localizationKit
            ]
        ),
        .make(
            name: "ChangeFolder",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.changeFolder",
            sources: ["ChangeFolderScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.service),
                .core(.model),
                .localizationKit
            ]
        ),
        .make(
            name: "AISummary",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.aiSummary",
            sources: ["AISummaryScene/**"],
            dependencies: [
                .spm(.composableArchitecture),
                .designSystem,
                .core(.service),
                .core(.model),
                .localizationKit
            ]
        )
    ]
)
