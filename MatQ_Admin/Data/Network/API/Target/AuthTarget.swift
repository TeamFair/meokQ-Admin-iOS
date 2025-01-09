//
//  AuthTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 12/27/24.
//

import Alamofire
import Foundation

enum AuthTarget {
    case login(PostAuthRequest)
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return URL.makeEndPoint(.open(endPoint: ""))
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        }
    }
    
    var path: String? {
        switch self {
        case .login: return "login"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .login(let request): return .body(request)
        }
    }
}
