//
//  TargetType.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import SwiftUI
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String? { get }
    var parameters: RequestParams { get }
}

extension TargetType {

    /// URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest: URLRequest
        if let path = path {
            urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        } else {
            urlRequest = try URLRequest(url: url, method: method)
        }
        urlRequest.setValue(HTTPHeaderField.acceptType.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(HTTPHeaderField.authentication.value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        if urlRequest.method == .post {
            urlRequest.setValue(HTTPHeaderField.contentType.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        switch parameters {
        case .query(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components: URLComponents?
            if let path = path {
                components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            } else {
                components =  URLComponents(string: url.absoluteString)
            }
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .body(let request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .queryAndBody(let queryRequest, let bodyRequest):
            let queryParams = queryRequest?.toDictionary() ?? [:]
            let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components: URLComponents?
            if let path = path {
                components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            } else {
                components =  URLComponents(string: url.absoluteString)
            }
            components?.queryItems = queryItems
            urlRequest.url = components?.url
            
            let bodyParams = bodyRequest?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        }

        return urlRequest
    }
}

enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
    case queryAndBody(query: Encodable?, body: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
