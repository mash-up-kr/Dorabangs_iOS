import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Coordinator",
    targets: [
        .make(
            name: "AppCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.appCoordinator",
            sources: ["AppCoordinator/**"],
            dependencies: [
                .scene(.onboarding),
                .scene(.splash),
                .coordinator(.tab),
                .spm(.tcaCoordinators)
            ]
        ),
        .make(
            name: "TabCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.tabCoordinator",
            sources: ["TabCoordinator/**"],
            dependencies: [
                .core(.model),
                .coordinator(.home),
                .coordinator(.storageBox),
                .spm(.tcaCoordinators),
                .designSystem,
                .localizationKit
            ]
        ),
        .make(
            name: "HomeCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.homeCoordinator",
            sources: ["HomeCoordinator/**"],
            dependencies: [
                .scene(.home),
                .scene(.createNewFolder),
                .scene(.saveURLVideoGuide),
                .coordinator(.webView),
                .coordinator(.aiClassification),
                .coordinator(.feed),
                .coordinator(.saveURL),
                .spm(.tcaCoordinators),
                .localizationKit
            ]
        ),
        .make(
            name: "StorageBoxCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.homeCoordinator",
            sources: ["StorageBoxCoordinator/**"],
            dependencies: [
                .scene(.storageBox),
                .spm(.tcaCoordinators),
                .coordinator(.feed),
                .coordinator(.saveURL),
                .scene(.changeFolderName),
                .scene(.createNewFolder),
                .localizationKit
            ]
        ),
        .make(
            name: "FeedCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.feedCoordinator",
            sources: ["FeedCoordinator/**"],
            dependencies: [
                .core(.model),
                .scene(.feed),
                .spm(.tcaCoordinators),
                .scene(.changeFolderName),
                .scene(.createNewFolder),
                .coordinator(.webView)
            ]
        ),
        .make(
            name: "SaveURLCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.saveURLCoordinator",
            sources: ["SaveURLCoordinator/**"],
            dependencies: [
                .scene(.saveURL),
                .scene(.selectFolder),
                .scene(.createNewFolder),
                .scene(.changeFolder),
                .spm(.tcaCoordinators)
            ]
        ),
        .make(
            name: "AIClassificationCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.aiClassificationCoordinator",
            sources: ["AIClassificationCoordinator/**"],
            dependencies: [
                .scene(.aiClassification),
                .coordinator(.feed),
                .spm(.tcaCoordinators)
            ]
        ),
        .make(
            name: "WebViewCoordinator",
            product: .staticLibrary,
            bundleId: "com.mashup.dorabangs.webViewCoordinator",
            sources: ["WebViewCoordinator/**"],
            dependencies: [
                .scene(.web),
                .scene(.aiSummary),
                .spm(.tcaCoordinators)
            ]
        )
    ]
)
