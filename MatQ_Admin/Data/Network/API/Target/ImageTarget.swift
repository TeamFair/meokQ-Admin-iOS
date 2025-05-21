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
    case getImageIds(GetImageIdsRequest)
    case postImage(PostImageRequest)
    case deleteImage(DeleteImageRequest)
}

extension ImageTarget: TargetType {
    
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "image"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getImage: return .get
        case .getImageIds: return .get
        case .postImage: return .post
        case .deleteImage: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getImage(let request): return request.imageId
        case .getImageIds: return nil
        case .postImage: return nil
        case .deleteImage(let request): return request.imageId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getImage: return .query(.none)
        case .getImageIds(let request): return .query(request)
        case .postImage(let request): return .query(request.type)
        case .deleteImage: return .query(.none)
        }
    }
}
