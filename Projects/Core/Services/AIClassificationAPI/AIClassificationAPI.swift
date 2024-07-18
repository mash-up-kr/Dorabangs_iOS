//
//  AIClassificationAPI.swift
//  Services
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum AIClassificationAPI: APIRepresentable {
    case getFolders
}

extension AIClassificationAPI {
    var path: String {
        switch self {
        case .getFolders:
            "/classification/folders"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders: .get
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? {
        switch self {
        case .getFolders: .none
        }
    }

    var httpBody: BodyParameters? { nil }
}
