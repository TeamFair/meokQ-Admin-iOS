//
//  HttpHeaderField.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Alamofire
import Foundation

enum HTTPHeaderField: String {
    case authentication = "authorization"
    case contentType = "Content-Type"
    case acceptType = "accept"
    
    var value: String {
        switch self {
        case .authentication:
            return Bundle.main.adminAuthToken
        case .contentType:
            return ""
        case .acceptType:
            return "application/json"
        }
    }
}

enum ContentType: String {
    case json = "Application/json"
}

