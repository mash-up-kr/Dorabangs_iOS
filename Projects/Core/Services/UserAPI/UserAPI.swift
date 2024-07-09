//
//  UserAPI.swift
//  Services
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum UserAPI: APIRepresentable {
    case postUsers(deviceToken: String)
}

extension UserAPI {
    var path: String { "/users" }

    var method: HTTPMethod { .post }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case let .postUsers(deviceToken): .dictionary(["deviceToken": deviceToken])
        }
    }
}
