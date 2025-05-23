//
//  NetworkError.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Alamofire

enum NetworkError: Error {
    case decodingError(Error)
    case serverError
    case invalidImageData
    case invalidResponse
    case error((Int, String, String)) // StatusCode, Status, ErrMessage
    case unknownError
    
    var message: String {
        switch self {
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .serverError:
            return "서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .invalidImageData:
            return "유효하지 않은 이미지 데이터입니다."
        case .invalidResponse:
            return "잘못된 응답을 받았습니다."
        case .error((let statusCode, let status, let errMessage)):
            // errMessage가 있으면 사용, 없으면 기본 메시지
            if !errMessage.isEmpty {
                return errMessage
            } else {
                return "서버 오류가 발생했습니다. (상태 코드: \(statusCode), 상태: \(status))"
            }
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
