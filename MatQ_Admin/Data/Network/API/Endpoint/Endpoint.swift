//
//  Endpoint.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Foundation

extension URL {
    static func makeEndPoint(_ target: EndPointTarget) -> String {
        let baseURL = NetworkConfiguration.shared.completeBaseURL
        return baseURL + "/api/" + target.type + "/" + target.endPoint
    }
}

enum EndPointTarget {
    case open(endPoint: String)
    case customer(endPoint:String)
    case boss(endPoint:String)
    case admin(endPoint:String)
    
    var type: String {
        switch self {
        case .customer:
            return "customer"
        case .open:
            return "open"
        case .boss:
            return "boss"
        case .admin:
            return "admin"
        }
    }
    
    var endPoint: String {
        switch self {
        case .open(let endPoint):
            return endPoint
        case .customer(let endPoint):
            return endPoint
        case .boss(let endPoint):
            return endPoint
        case .admin(let endPoint):
            return endPoint
        }
    }
}
