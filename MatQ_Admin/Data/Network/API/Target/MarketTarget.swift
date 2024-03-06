//
//  MarketTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Alamofire
import Foundation

enum MarketTarget {
    case getMarketList(GetMarketListRequest)
    case getMarketDetail(GetMarketDetailRequest)
}

extension MarketTarget: TargetType {
    
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "market"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMarketList: return .get
        case .getMarketDetail: return .get
        }
    }
    
    var path: String? {
        switch self {
        case .getMarketList: return nil
        case .getMarketDetail(let request): return request.marketId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getMarketList(let request): return .query(request)
        case .getMarketDetail: return .query(.none)
        }
    }
}
