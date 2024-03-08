//
//  ImageTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/8/24.
//

import Alamofire
import Foundation

enum ImageTarget {
    case getImage(GetImageRequest)
    case deleteImage(DeleteImageRequest)
}

extension ImageTarget: TargetType {
    
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "image"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getImage: return .get
        case .deleteImage: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getImage(let request): return request.imageId
        case .deleteImage(let request): return request.imageId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getImage: return .query(.none)
        case .deleteImage: return .query(.none)
        }
    }
}
