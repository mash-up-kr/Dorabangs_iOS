import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
	name: "Scene",
	targets: [
		.make(
			name: "Home",
			product: .staticLibrary,
			bundleId: "com.mashup.dorabangs.home",
			sources: ["HomeScene/**"],
			dependencies: [
				.spm(.composableArchitecture),
				.designSystem
			]
		),
		.make(
			name: "Splash",
			product: .staticLibrary,
			bundleId: "com.mashup.dorabangs.splash",
			sources: ["SplashScene/**"],
			dependencies: [
				.spm(.composableArchitecture)
			]
		),
		.make(
			name: "Folder",
			product: .staticLibrary,
			bundleId: "com.mashup.dorabangs.folder",
			sources: ["FolderScene/**"],
			dependencies: [
				.spm(.composableArchitecture)
			]
		),
		.make(
			name: "Web",
			product: .staticLibrary,
			bundleId: "com.mashup.dorabangs.web",
			sources: ["WebScene/**"],
			dependencies: [
				.spm(.composableArchitecture)
			]
		)
	]
)
