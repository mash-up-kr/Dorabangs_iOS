//
//  DataLoadingStatus.swift
//  Services
//
//  Created by 박소현 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case testAPI
}
//extension API: TargetType {
//    var baseURL: URL {
//        return URL(string: "")!
//    }
//    
//    var path: String {
//        switch self {
//        case .testAPI:
//            return ""
//        }
//    }
//    
//    var method: Alamofire.HTTPMethod {
//        switch self {
//        case .testAPI:
//            return .post
//        }
//    }
//    
//    
//    
//    var task: Task {
//        //
//    }
//
//    
//    func asURLRequest() throws -> URLRequest {
//        //
//    }
//    
//    
//}
public protocol TargetType: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var task: Task { get }
}
public extension TargetType {
  /// Default is `["Content-Type": "application/json"]`
  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
  /// Provides stub data for use in testing. Default is `Data()`.
  var sampleData: Data {
    return Data()
  }
}
public enum Task {
    /// A request with no additional data.
    case requestPlain
}
