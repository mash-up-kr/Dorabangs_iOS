//
//  URL+init.swift
//  Services
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

extension URL {
    init(target: some APIRepresentable) throws {
        let path = target.path
        guard let baseURL = URL(string: Secrets.baseURL) else {
            throw AFError.invalidURL(url: Secrets.baseURL)
        }
        if path.isEmpty {
            self = baseURL
        } else {
            self = baseURL.appendingPathComponent(path)
        }
    }
}
