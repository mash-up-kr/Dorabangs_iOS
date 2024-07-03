import ProjectDescription

public enum Module {
	case core(Core)
	case coordinator(Coordinator)
	case designSystem
	case scene(Scene)
	case spm(SPM)
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
	case saveURL = "SaveURLCoordinator"
}

public enum Scene: String {
	case storageBox = "StorageBox"
	case home = "Home"
	case splash = "Splash"
	case web = "Web"
	case saveURL = "SaveURL"
	case createNewFolder = "CreateNewFolder"
}

public enum SPM: String {
	case alamofire = "Alamofire"
	case composableArchitecture = "ComposableArchitecture"
	case tcaCoordinators = "TCACoordinators"
}

extension Module {
	public func asTargetDependency() -> TargetDependency {
		switch self {
		case .core(let core):
			return .project(target: core.rawValue, path: .relativeToRoot("Projects/Core/\(core.rawValue)"))
			
		case .coordinator(let coordinator):
			return .project(target: coordinator.rawValue, path: .relativeToRoot("Projects/Features/Coordinator"))
			
		case .designSystem:
			return .project(target: "DesignSystemKit", path: .relativeToRoot("Projects/DesignSystem"))
			
		case .scene(let scene):
			return .project(target: scene.rawValue, path: .relativeToRoot("Projects/Features/Scene"))
			
		case .spm(let spm):
			return .external(name: spm.rawValue)
			
		}
	}
}
