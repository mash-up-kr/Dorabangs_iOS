//
//  HomeAPI.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum HomeAPI: APIRepresentable {
    case getFolders
}

extension HomeAPI {
    var path: String { "/folders" }

    var method: HTTPMethod {
        switch self {
        case .getFolders:
            return .get
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getFolders:
                .none
        }
    }
}
