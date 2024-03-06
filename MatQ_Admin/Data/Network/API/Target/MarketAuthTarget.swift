//
//  MarketAuthTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Alamofire
import Foundation

enum MarketAuthTarget {
    case getMarketAuth(GetMarketAuthRequest)
    case putMarketAuthReview(PutReviewMarketAuthRequest)
}

extension MarketAuthTarget: TargetType {
    
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "market-auth"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMarketAuth: return.get
        case .putMarketAuthReview: return .put
        }
    }
    
    var path: String? {
        switch self {
        case .getMarketAuth: return nil
        case .putMarketAuthReview: return "review"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getMarketAuth(let request): return .query(request)
        case .putMarketAuthReview(let request): return .body(request)
        }
    }
}
