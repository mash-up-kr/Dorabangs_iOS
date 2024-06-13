import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
	name: "DesignSystem",
	targets: [
		.make(
			name: "DesignSystem",
			product: .framework,
			bundleId: "com.mashup.dorabangs.designSystem",
			sources: ["Sources/**"],
			resources: ["Resources/**"]
		)
	],
	resourceSynthesizers: [
		.assets(),
		.fonts()
	]
)
