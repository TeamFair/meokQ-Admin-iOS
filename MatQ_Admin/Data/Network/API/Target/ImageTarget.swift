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
        case .postImage: return .post
        case .deleteImage: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getImage(let request): return request.imageId
        case .postImage: return nil
        case .deleteImage(let request): return request.imageId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getImage: return .query(.none)
        case .postImage(let request): return .queryAndBody(query: request.type, body: request.data)
        case .deleteImage: return .query(.none)
        }
    }
}
