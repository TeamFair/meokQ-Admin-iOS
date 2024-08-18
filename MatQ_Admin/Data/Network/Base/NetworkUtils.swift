//
//  NetworkUtils.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import Alamofire
import UIKit

enum NetworkUtils {
    static func request<T: Decodable>(_ target: URLRequestConvertible, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        AF.request(target)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
    
    static func requestImage(_ target: URLRequestConvertible) -> AnyPublisher<UIImage, NetworkError> {
        AF.request(target)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let data = response.data, let image = UIImage(data: data) else {
                    throw NetworkError.decodingError
                }
                return image
            }
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
    
    static func upload<T: Decodable>(_ target: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData) -> Void, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        AF.upload(multipartFormData: multipartFormData, with: target)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
}
