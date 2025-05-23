//
//  BannerTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Alamofire
import Foundation

enum BannerTarget {
    case getBanner(GetBannersRequest)
    case postBanner(PostBannerRequest)
    case putBanner(PutBannerRequest)
    case deleteBanner(DeleteBannerRequest)
}

extension BannerTarget: TargetType {
    var baseURL: String {
        switch self {
        case .getBanner: return URL.makeEndPoint(.open(endPoint: "v1/banners"))
        case .postBanner: return URL.makeEndPoint(.admin(endPoint: "v1/banners/new"))
        case .putBanner: return URL.makeEndPoint(.admin(endPoint: "v1/banners/"))
        case .deleteBanner: return URL.makeEndPoint(.admin(endPoint: "v1/banners/"))
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBanner: return .get
        case .postBanner: return .post
        case .putBanner: return .put
        case .deleteBanner: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getBanner: return nil
        case .postBanner: return nil
        case .putBanner(let request): return String(request.bannerId)
        case .deleteBanner(let request): return String(request.bannerId)
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getBanner(let request): return .query(request)
        case .postBanner(let request): return .body(request)
        case .putBanner(let request): return .body(request.banner)
        case .deleteBanner: return .query(nil)
        }
    }
}
