import ProjectDescription

public extension TargetScript {
	static let copyGoogleServiceInfoPlistScript = TargetScript.pre(
		path: .script.copyGoogleServiceInfo,
		name: "Copy GoogleService-Info.plist",
		basedOnDependencyAnalysis: false
	)
	
	static let uploadDsymsScript = TargetScript.post(
		path: .script.uploadDsyms,
		name: "Upload dSYMs",
		inputPaths: [
			"${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
			"${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
			"${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
			"$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
			"$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
		],
		basedOnDependencyAnalysis: false
	)
}
