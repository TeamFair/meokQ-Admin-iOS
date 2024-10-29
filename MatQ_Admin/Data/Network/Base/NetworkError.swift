//
//  NetworkError.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError),
            (.serverError, .serverError),
            (.invalidImageData, .invalidImageData),
            (.unknownError, .unknownError):
            return true
        case let (.error(lhsData), .error(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
    
    case decodingError
    case serverError
    case invalidImageData
    
    case error((Int, String, String)) // StatusCode, Status, ErrMessage
    case unknownError
}
