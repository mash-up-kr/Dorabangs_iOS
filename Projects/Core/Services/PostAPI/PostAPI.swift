//
//  PostAPI.swift
//  Services
//
//  Created by 안상희 on 7/16/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum CardAPI: APIRepresentable {
    case postCard(folderId: String, urlString: String)
}

extension CardAPI {
    var path: String { "/posts" }

    var method: HTTPMethod { .post }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case let .postCard(folderId, urlString):
            .dictionary(["folderId": folderId, "url": urlString])
        }
    }
}
