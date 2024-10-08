//
//  KeychainClient.swift
//  Services
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import KeychainAccess

// MARK: - Interface
@DependencyClient
public struct KeychainClient: Sendable {
    public var setBool: @Sendable (Bool, String) -> Void
    public var setString: @Sendable (String, String) -> Void
    public var boolForKey: @Sendable (String) -> Bool = { _ in false }
    public var stringForKey: @Sendable (String) -> String?
    public var remove: @Sendable (String) -> Void
}

enum KeychainKey {
    static let accessToken = "accessToken"
    static let udid = "udid"
    static let hasOnboarded = "hasOnboarded"
}

public extension KeychainClient {
    var accessToken: String? {
        stringForKey(KeychainKey.accessToken)
    }

    func setAccessToken(_ assessToken: String) {
        setString(assessToken, KeychainKey.accessToken)
    }

    var udid: String? {
        stringForKey(KeychainKey.udid)
    }

    func setUDID(_ udid: String) {
        setString(udid, KeychainKey.udid)
    }

    var hasOnboarded: Bool {
        boolForKey(KeychainKey.hasOnboarded)
    }

    func setHasOnboarded(_ hasOnboarded: Bool) {
        setBool(hasOnboarded, KeychainKey.hasOnboarded)
    }
}

public extension DependencyValues {
    var keychainClient: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}

// MARK: - Live
extension KeychainClient: DependencyKey {
    public static var liveValue: KeychainClient {
        guard let appIdentifierPrefix = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String else {
            fatalError("AppIdentifierPrefix is not set in Info.plist")
        }
        let keychain = Keychain(service: "com.mashup.dorabangs", accessGroup: "\(appIdentifierPrefix)group.com.mashup.dorabangs")
        return KeychainClient(
            setBool: { keychain[$1] = $0 ? "true" : "false" },
            setString: { keychain[$1] = $0 },
            boolForKey: { keychain[$0] == "true" },
            stringForKey: { keychain[$0] },
            remove: { keychain[$0] = nil }
        )
    }
}
