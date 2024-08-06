import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "LocalizationKit",
    targets: [
        .make(
            name: "LocalizationKit",
            product: .framework,
            bundleId: "com.mashup.dorabangs.localizationKit",
            resources: ["Resources/**"]
        )
    ],
    resourceSynthesizers: [
        .strings()
    ]
)
