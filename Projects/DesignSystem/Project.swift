import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
	name: "DesignSystem",
	targets: [
		.make(
			name: "DesignSystemUI",
			product: .app,
			bundleId: "com.mashup.dorabangs.designSystemUI",
			infoPlist: .extendingDefault(with: ["UILaunchStoryboardName": "LaunchScreen.storyboard"]),
			sources: ["DesignSystemUI/Sources**"],
			resources: ["DesignSystemUI/Resources/**"],
			dependencies: [
				.designSystem
			]
		),
		.make(
			name: "DesignSystemKit",
			product: .framework,
			bundleId: "com.mashup.dorabangs.designSystemKit",
			sources: ["DesignSystemKit/Sources/**"],
			resources: ["DesignSystemKit/Resources/**"]
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
		.fonts()
	]
)
