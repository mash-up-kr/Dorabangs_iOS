//
//  URLValidatorClient.swift
//  Services
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct URLValidatorClient {
    /// URL을 검증하고, 유효한 URL을 반환합니다.
    public var validateURL: @Sendable (URL) async -> URL?
}

extension URLValidatorClient: DependencyKey {
    public static var liveValue: URLValidatorClient = Self(
        validateURL: { url in
            let urlValidator = URLValidator(url: url)
            return await urlValidator.validate()
        }
    )

    actor URLValidator {
        let url: URL

        init(url: URL) {
            self.url = url
        }

        // URL에 요청을 보내 응답을 검증합니다.
        func validate() async -> URL? {
            guard let formattedURL = formatURL() else { return nil }

            let request = createHEADRequest(for: formattedURL)
            do {
                let response = try await URLSession.shared.data(for: request).1
                if let httpResponse = response as? HTTPURLResponse, isValidResponse(httpResponse) {
                    return response.url
                }
            } catch {}
            return nil
        }

        private func formatURL() -> URL? {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if components?.scheme == nil {
                components?.scheme = "https"
            }
            return components?.url
        }

        private func createHEADRequest(for url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            return request
        }

        private func isValidResponse(_ response: HTTPURLResponse) -> Bool {
            (200 ..< 300).contains(response.statusCode)
        }
    }
}

public extension DependencyValues {
    var urlValidatorClient: URLValidatorClient {
        get { self[URLValidatorClient.self] }
        set { self[URLValidatorClient.self] = newValue }
    }
}
