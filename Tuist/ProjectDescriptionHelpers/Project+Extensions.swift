import ProjectDescription

extension Project {
	public static func make(
		name: String,
		packages: [Package] = [],
		targets: [Target],
		schemes: [Scheme] = [],
		additionalFiles: [FileElement] = [],
		resourceSynthesizers: [ResourceSynthesizer] = []
	) -> Project {
		return Project(
			name: name,
			organizationName: "mashup.dorabangs",
			options: .options(
				automaticSchemesOptions: .disabled,
				defaultKnownRegions: ["en", "ko"],
				developmentRegion: "ko",
				textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
			),
			packages: packages,
			settings: .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "15.0"]),
			targets: targets,
			schemes: schemes,
			additionalFiles: additionalFiles,
			resourceSynthesizers: resourceSynthesizers
		)
	}
}
