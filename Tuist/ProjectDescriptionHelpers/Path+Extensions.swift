import ProjectDescription

public extension Path {
	enum script {
		public static let copyGoogleServiceInfo = Path.relativeToRoot("ci_scripts/copy_google_service_info.sh")
		public static let uploadDsyms = Path.relativeToRoot("ci_scripts/upload_dsyms.sh")
	}
	
	enum plist {
		public static let googleServiceInfoDebug = Path.relativeToRoot("Projects/App/InfoPlists/GoogleService-Info-Debug.plist")
		public static let googleServiceInfoRelease = Path.relativeToRoot("Projects/App/InfoPlists/GoogleService-Info-Release.plist")		
	}
}
