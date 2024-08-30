//
//  NetworkError.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

enum NetworkError: Error {
    case decodingError
    case serverError
    case invalidImageData
    
    case error((Int, String, String)) // StatusCode, Status, ErrMessage
    case unknownError
}
