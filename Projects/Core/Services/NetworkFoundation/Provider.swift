//
//  Provider.swift
//  Services
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

public struct Provider {
    private let session: Session
    private let requestHeaderInterceptor: RequestInterceptor = RequestHeaderInterceptor()

    public init() {
        let logger = NetworkEventLogger()
        self.session = Alamofire.Session(configuration: .default, eventMonitors: [logger])
    }

    public func request<T: Decodable>(_ api: APIRepresentable) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            session.request(api, interceptor: requestHeaderInterceptor).responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        try processSuccessResponse(response: response, data: data, continuation: continuation)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingError(error))
                    }
                case let .failure(error):
                    continuation.resume(throwing: NetworkError.underlying(error))
                }
            }
        }
    }
}

private extension Provider {
    func processSuccessResponse<T: Decodable>(response: AFDataResponse<Data>, data: Data, continuation: CheckedContinuation<T, Error>) throws {
        if let httpResponse = response.response, 200 ..< 400 ~= httpResponse.statusCode {
            let decodedResponse = try JSONDecoder().decode(BaseDataResponse<T>.self, from: data)
            if let responseData = decodedResponse.data {
                continuation.resume(returning: responseData)
            } else {
                continuation.resume(throwing: NetworkError.noData)
            }
        } else {
            try handleErrorResponse(data: data, continuation: continuation)
        }
    }

    func handleErrorResponse(data: Data, continuation: CheckedContinuation<some Decodable, Error>) throws {
        let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: data)
        let errorMessage = decodedError.error.message
        continuation.resume(throwing: NetworkError.invalidResponse(statusCode: errorMessage.statusCode, message: errorMessage.message))
    }
}

public enum NetworkError: Error {
    case underlying(AFError)
    case invalidResponse(statusCode: Int, message: String)
    case noData
    case decodingError(Error)

    var localizedDescription: String {
        switch self {
        case let .underlying(error):
            error.localizedDescription

        case let .invalidResponse(_, message):
            message

        case .noData:
            "No data available"

        case let .decodingError(error):
            "Decoding error: \(error.localizedDescription)"
        }
    }
}
