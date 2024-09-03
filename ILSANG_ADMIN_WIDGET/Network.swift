//
//  Network.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 9/2/24.
//

import Foundation

struct Network {
    static func request<T: Decodable>(url: String) async -> Result<T, Error> {
        
        guard let url = URL(string: url) else { return .failure(URLError(.badURL)) }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(HTTPHeaderField.authentication.value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        urlRequest.setValue(HTTPHeaderField.acceptType.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest) else {
            return .failure(URLError(.networkConnectionLost))
        }
        
        // HTTP 상태 코드 확인 (2xx 범위만 성공으로 간주)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            return .failure(URLError(.badServerResponse))
        }
        
        // JSON 디코딩
        guard let decodedResult = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Decoding failed")))
        }
        
        return .success(decodedResult)
    }
}

