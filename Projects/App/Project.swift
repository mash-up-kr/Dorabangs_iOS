import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/release.xcconfig")
let sharedConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/shared.xcconfig")
let shareExtensionDebugConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/debug-ShareExtension.xcconfig")
let shareExtensionReleaseConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/release-ShareExtension.xcconfig")
let shareExtensionSharedConfig = Path.relativeToRoot("Projects/App/ConfigurationFiles/shared-ShareExtension.xcconfig")

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
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/Prod-Dorabangs.entitlements")),
            scripts: [.copyGoogleServiceInfoPlistScript, .uploadDsymsScript],
            dependencies: [
                .coordinator(.app),
                .shareExtension(.prod)
            ],
            settings: .settings(
                configurations: [.release(name: .release, xcconfig: releaseConfig)],
                defaultSettings: .recommended(excluding: ["ASSETCATALOG_COMPILER_APPICON_NAME"])
            )
        ),
        .make(
            name: "Dev-Dorabangs",
            product: .app,
            bundleId: "com.mashup.dorabangs-dev",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/Dev-Dorabangs.entitlements")),
            scripts: [.copyGoogleServiceInfoPlistScript, .uploadDsymsScript],
            dependencies: [
                .coordinator(.app),
                .shareExtension(.dev)
            ],
            settings: .settings(
                configurations: [.debug(name: .debug, xcconfig: debugConfig)],
                defaultSettings: .recommended(excluding: ["ASSETCATALOG_COMPILER_APPICON_NAME"])
            )
        ),
        .make(
            name: "Prod-ShareExtension",
            product: .appExtension,
            bundleId: "com.mashup.dorabangs.share",
            infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/ShareExtension-Info.plist")),
            sources: ["ShareExtension/**"],
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/Prod-ShareExtension.entitlements")),
            dependencies: [
                .designSystem,
                .core(.service),
                .localizationKit
            ],
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
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/Dev-ShareExtension.entitlements")),
            dependencies: [
                .designSystem,
                .core(.service),
                .localizationKit
            ],
            settings: .settings(
                configurations: [.debug(name: .debug, xcconfig: shareExtensionDebugConfig)]
            )
        )
    ],
    additionalFiles: [
        .glob(pattern: sharedConfig),
        .glob(pattern: shareExtensionSharedConfig),
        .glob(pattern: .plist.googleServiceInfoDebug),
        .glob(pattern: .plist.googleServiceInfoRelease)
    ]
)
