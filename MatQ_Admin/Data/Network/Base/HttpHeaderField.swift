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
            return type.json.rawValue
        case .acceptType:
            return type.json.rawValue
        }
    }
    
    enum type: String {
        case json = "application/json"
    }
}
