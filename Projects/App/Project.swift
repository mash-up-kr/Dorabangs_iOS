import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/ConfigurationFiles/debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/ConfigurationFiles/release.xcconfig")
let sharedConfig = Path.relativeToRoot("Projects/ConfigurationFiles/shared.xcconfig")

let project = Project.make(
	name: "App",
	targets: [
		.make(
			name: "Prod-Dorabangs",
			product: .app,
			bundleId: "com.mashup.dorabangs",
			infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/Prod-Dorabangs.plist")),
			sources: ["Sources/**"],
			resources: ["Resources/**"],
			dependencies: [
				.coordinator(.app)
			],
			settings: .settings(configurations: [.release(name: .release,xcconfig: releaseConfig)])
		),
		.make(
			name: "Dev-Dorabangs",
			product: .app,
			bundleId: "com.mashup.dorabangs-dev",
			infoPlist: .file(path: .relativeToRoot("Projects/App/InfoPlists/Dev-Dorabangs.plist")),
			sources: ["Sources/**"],
			resources: ["Resources/**"],
			dependencies: [
				.coordinator(.app)
			],
			settings: .settings(configurations: [.debug(name: .debug, xcconfig: debugConfig)])
		)
	],
	additionalFiles: [.glob(pattern: sharedConfig)]
)
