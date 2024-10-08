import ProjectDescription

public enum Module {
	case core(Core)
	case coordinator(Coordinator)
	case designSystem
	case scene(Scene)
	case spm(SPM)
	case shareExtension(ShareExtension)
	case localizationKit
}

public enum Core: String {
	case common = "Common"
	case model = "Models"
	case service = "Services"
}

public enum Coordinator: String {
	case app = "AppCoordinator"
	case tab = "TabCoordinator"
	case home = "HomeCoordinator"
	case storageBox = "StorageBoxCoordinator"
    case feed = "FeedCoordinator"
	case saveURL = "SaveURLCoordinator"
	case aiClassification = "AIClassificationCoordinator"
	case changeFolder = "ChangeFolderCoordinator"
	case webView = "WebViewCoordinator"
}

public enum Scene: String {
	case storageBox = "StorageBox"
	case home = "Home"
	case splash = "Splash"
	case web = "Web"
    case feed = "Feed"
	case saveURL = "SaveURL"
	case selectFolder = "SelectFolder"
	case createNewFolder = "CreateNewFolder"
	case onboarding = "Onboarding"
    case changeFolderName = "ChangeFolderName"
	case aiClassification = "AIClassification"
	case saveURLVideoGuide = "SaveURLVideoGuide"
	case changeFolder = "ChangeFolder"
	case aiSummary = "AISummary"
}

public enum SPM: String {
	case acarousel = "ACarousel"
    case alamofire = "Alamofire"
	case composableArchitecture = "ComposableArchitecture"
	case tcaCoordinators = "TCACoordinators"
	case keychainAccess = "KeychainAccess"
	case kingfisher = "Kingfisher"
	case lottie = "Lottie"
	case firebaseAnalytics = "FirebaseAnalytics"
	case firebaseCrashlytics = "FirebaseCrashlytics"
}

public enum ShareExtension: String {
	case dev = "Dev-ShareExtension"
	case prod = "Prod-ShareExtension"
}

extension Module {
	public func asTargetDependency() -> TargetDependency {
		switch self {
		case .core(let core):
			return .project(target: core.rawValue, path: .relativeToRoot("Projects/Core"))
			
		case .coordinator(let coordinator):
			return .project(target: coordinator.rawValue, path: .relativeToRoot("Projects/Features/Coordinator"))
			
		case .designSystem:
			return .project(target: "DesignSystemKit", path: .relativeToRoot("Projects/DesignSystem"))
			
		case .scene(let scene):
			return .project(target: scene.rawValue, path: .relativeToRoot("Projects/Features/Scene"))
			
		case .spm(let spm):
			return .external(name: spm.rawValue)
		
		case .shareExtension(let shareExtension):
			return .target(name: shareExtension.rawValue)
			
		case .localizationKit:
			return .project(target: "LocalizationKit", path: .relativeToRoot("Projects/LocalizationKit"))
		}
	}
}
