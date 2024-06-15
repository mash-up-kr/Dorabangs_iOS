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
				textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
			),
			packages: packages,
			targets: targets,
			schemes: schemes,
			additionalFiles: additionalFiles,
			resourceSynthesizers: resourceSynthesizers
		)
	}
}
