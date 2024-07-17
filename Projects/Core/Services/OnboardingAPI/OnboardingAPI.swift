//
//  OnboardingAPI.swift
//  Services
//
//  Created by 김영균 on 7/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum OnboardingAPI: APIRepresentable {
    case getKeywords
}

extension OnboardingAPI {
    var path: String { "/onboard" }

    var method: HTTPMethod { .get }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? { nil }
}
