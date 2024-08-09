//
//  NetworkError.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

enum NetworkError: Error {
    case decodingError
    case serverError
    case unknownError
    case invalidImageData
}
