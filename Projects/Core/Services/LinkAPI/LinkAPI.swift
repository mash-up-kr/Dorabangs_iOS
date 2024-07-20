//
//  LinkAPI.swift
//  Services
//
//  Created by 박소현 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum LinkAPI: APIRepresentable {
    /// 링크 유효성 체크
    case getValidation(link: String)
}

extension LinkAPI {
    var path: String {
        switch self {
        case .getValidation:
            "/links/validation"
        }
    }

    var method: HTTPMethod { .get }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? {
        switch self {
        case let .getValidation(link):
            ["link": link]
        }
    }

    var httpBody: BodyParameters? { nil }
}
