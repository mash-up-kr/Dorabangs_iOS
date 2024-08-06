import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "DesignSystem",
    targets: [
        .make(
            name: "DesignSystemUI",
            product: .app,
            bundleId: "com.mashup.dorabangs.designSystemUI",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "CFBunldeIconName": "AppIcon",
                    "ITSAppUsesNonExemptEncryption": "NO",
                    "ITSEncryptionExportComplianceCode": "false"
                ]
            ),
            sources: ["DesignSystemUI/Sources**"],
            resources: ["DesignSystemUI/Resources/**"],
            dependencies: [
                .designSystem
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "8ATYCP492F",
                    "CODE_SIGN_STYLE": "Manual",
                    "PROVISIONING_PROFILE_SPECIFIER": "Distribution com.mashup.dorabangs.designSystemUI",
                    "CODE_SIGN_IDENTITY": "Apple Distribution: YoungGyun Kim (8ATYCP492F)"
                ]
            )
        ),
        .make(
            name: "DesignSystemKit",
            product: .framework,
            bundleId: "com.mashup.dorabangs.designSystemKit",
            infoPlist: .extendingDefault(with: ["UIAppFonts": "NanumSquareNeo-Variable.ttf"]),
            sources: ["DesignSystemKit/Sources/**"],
            resources: ["DesignSystemKit/Resources/**"],
            dependencies: [
                .spm(.lottie),
                .localizationKit
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "DesignSystemUI",
            buildAction: .buildAction(targets: ["DesignSystemUI"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release)
        )
    ],
    resourceSynthesizers: [
        .assets(),
        .custom(name: "JSON", parser: .json, extensions: ["json"])
    ]
)
