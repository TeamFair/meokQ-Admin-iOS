//
//  APINetworkService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import Alamofire
import UIKit

protocol NetworkServiceInterface {
    func request<T: Decodable>(_ target: URLRequestConvertible, as type: T.Type) -> AnyPublisher<T, NetworkError>
    func requestImage(_ target: URLRequestConvertible) -> AnyPublisher<UIImage, NetworkError>
    func upload<T: Decodable>(_ target: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData) -> Void, as type: T.Type) -> AnyPublisher<T, NetworkError>
}

class NetworkService: NetworkServiceInterface {
    
    /// #57 - 응답이 실패했을 때 (응답코드, 디코딩한 status, 디코딩한 에러메시지)를 반환
    func request<T: Decodable>(_ target: URLRequestConvertible, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        logRequestURL(target: target)
       
        return AF.request(target)
            .validate()
            .publishData(emptyResponseCodes: [200, 204, 205])
            .tryMap { result -> T in
                if let error = result.error {
                    if let data = result.data {
                        let errorResponse: ErrorResponse
                        do {
                            errorResponse = try self.decode(from: data)
                            print("NetworkService - 응답 실패, 에러 디코딩 결과: \(errorResponse)")
                        } catch {
                            throw NetworkError.decodingError(error)
                        }
                        
                        throw NetworkError.error((
                            result.response?.statusCode ?? 0,
                            errorResponse.status,
                            errorResponse.errMessage
                        ))
                    } else {
                        print("NetworkService - 응답 에러: \(error)")
                        throw NetworkError.unknownError
                    }
                }
                
                if let data = result.data {
                    let value: T = try self.decode(from: data)
                    if T.self != ResponseWithPage<[GetQuestResponseData]>.self {
                        print("Response: \(value)")
                    }
                    return value
                } else {
                    return ResponseWithEmpty() as! T
                }
            }
            .mapError({ error -> NetworkError in
                if let apiError = error as? NetworkError {
                    return apiError
                } else {
                    return .unknownError
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestImage(_ target: URLRequestConvertible) -> AnyPublisher<UIImage, NetworkError> {
        AF.request(target)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let data = response.data, let image = UIImage(data: data) else {
                    throw NetworkError.invalidImageData
                }
                return image
            }
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
    
    func upload<T: Decodable>(_ target: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData) -> Void, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        logRequestURL(target: target)
        
        return AF.upload(multipartFormData: multipartFormData, with: target)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
}

extension NetworkService {
    func logRequestURL(target: URLRequestConvertible) {
#if DEBUG
        let urlRequest = try? target.asURLRequest()
        print("Request URL: \(urlRequest?.url?.absoluteString ?? "No URL")")
#endif
    }
    
    func decode<T: Decodable>(from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("NetworkService - 응답 실패, 에러 디코딩 실패: \(String(data: data, encoding: .utf8) ?? "N/A") \(error)")
            throw error
        }
    }
}
