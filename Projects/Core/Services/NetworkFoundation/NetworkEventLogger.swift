//
//  NetworkEventLogger.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation
import os.log

final class NetworkEventLogger: EventMonitor {
    let logger = Logger(subsystem: "com.mashup.dorabangs", category: "NetworkEventLogger")
    let queue = DispatchQueue(label: "NetworkEventLogger")

    func requestDidFinish(_ request: Request) {
        var message = """
        =============== 🎈 Network Request Log 🎈 ===============
        ✅ [URL] : \(request.request?.url?.absoluteString ?? "")
        ✅ [Method] : \(request.request?.httpMethod ?? "")
        ✅ [Headers] : \(request.request?.allHTTPHeaderFields ?? [:])
        """

        if let body = request.request?.httpBody?.toPrettyPrintedString {
            message += "\n✅ [Body]: \(body)"
        } else {
            message += "\n✅ [Body]: Body가 없습니다."
        }

        logger.log(level: .debug, "\(message)")
    }

    func request(
        _: DataRequest,
        didParseResponse response: DataResponse<some Any, AFError>
    ) {
        var message = "=============== 🎈 Network Response Log 🎈 ==============="

        switch response.result {
        case .success:
            message += "\n✅ [Status Code] : \(response.response?.statusCode ?? 0)"
        case .failure:
            message += "\n❎ 요청에 실패했습니다."
        }

        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 400 ..< 500:
                message += "\n❎ 클라이언트 오류"
            case 500 ..< 600:
                message += "\n❎ 서버 오류"
            default:
                break
            }
        }

        if let networkDuration = response.metrics.map({ "\($0.taskInterval.duration)s" }) {
            message += "\n✅ [Network Duration] : \(networkDuration)"
        }

        if let response = response.data?.toPrettyPrintedString {
            message += "\n✅ [Response] : \(response)"
        }

        logger.log(level: .debug, "\(message)")
    }

    func request(
        _: Request,
        didFailTask _: URLSessionTask,
        earlyWithError error: AFError
    ) {
        logger.log(level: .error, "❎ Did Fail Task Early With Error: \(error.localizedDescription)")
    }

    func request(
        _: Request,
        didFailToCreateURLRequestWithError error: AFError
    ) {
        logger.log(level: .error, "❎ Did Fail To Create URLRequest With Error: \(error.localizedDescription)")
    }

    func requestDidCancel(_: Request) {
        logger.log(level: .debug, "❎ Request Did Cancel")
    }
}

private extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else {
            return nil
        }
        return prettyPrintedString as String
    }
}
