//
//  NoticeTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Alamofire
import Foundation

enum NoticeTarget {
    case getNotice(GetNoticeRequest)
    case postNotice(PostNoticeRequest)
    case deleteNotice(DeleteNoticeRequest)
}

extension NoticeTarget: TargetType {
    
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "notice"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotice: return .get
        case .postNotice: return .post
        case .deleteNotice: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getNotice: return nil
        case .postNotice: return nil
        case .deleteNotice(let request): return request.noticeId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getNotice(let request): return .query(request)
        case .postNotice(let request): return .body(request)
        case .deleteNotice(let request): return .query(request)
        }
    }
}
