import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/ConfigurationFiles/debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/ConfigurationFiles/release.xcconfig")
let sharedConfig = Path.relativeToRoot("Projects/ConfigurationFiles/shared.xcconfig")
let shareExtensionDebugConfig = Path.relativeToRoot("Projects/ConfigurationFiles/debug-ShareExtension.xcconfig")
let shareExtensionReleaseConfig = Path.relativeToRoot("Projects/ConfigurationFiles/release-ShareExtension.xcconfig")
let shareExtensionSharedConfig = Path.relativeToRoot("Projects/ConfigurationFiles/shared-ShareExtension.xcconfig")

let project = Project.make(
    name: "App",
    targets: [
        .make(
            name: "Prod-Dorabangs",
            product: .app,
            bundleId: "com.mashup.dorabangs",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .coordinator(.app),
                .shareExtension(.prod)
            ],
            settings: .settings(
                configurations: [.release(name: .release, xcconfig: releaseConfig)]
            )
        ),
        .make(
            name: "Dev-Dorabangs",
            product: .app,
            bundleId: "com.mashup.dorabangs-dev",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .coordinator(.app),
                .shareExtension(.dev)
            ],
            settings: .settings(
                configurations: [.debug(name: .debug, xcconfig: debugConfig)]
            )
        ),
        .make(
            name: "Prod-ShareExtension",
            product: .appExtension,
            bundleId: "com.mashup.dorabangs.share",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/ShareExtension-Info.plist")),
            sources: ["ShareExtension/**"],
            dependencies: [.designSystem],
            settings: .settings(
                configurations: [.release(name: .release, xcconfig: shareExtensionReleaseConfig)]
            )
        ),
        .make(
            name: "Dev-ShareExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.mashup.dorabangs-dev.share",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/ShareExtension-Info.plist")),
            sources: ["ShareExtension/**"],
            dependencies: [.designSystem],
            settings: .settings(
                configurations: [.debug(name: .debug, xcconfig: shareExtensionDebugConfig)]
            )
        )
    ],
    additionalFiles: [.glob(pattern: sharedConfig), .glob(pattern: shareExtensionSharedConfig)]
)
