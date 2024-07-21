//
//  QuestTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Alamofire
import Foundation

enum QuestTarget {
    case getQuest(GetQuestRequest)
    case postQuest(PostQuestRequest)
    case deleteQuest(DeleteQuestRequest)
}

extension QuestTarget: TargetType {
    var baseURL: String {
        return URL.makeEndPoint(.admin(endPoint: "quest"))
    }
    
    var method: HTTPMethod {
        switch self {
        case .getQuest: return .get
        case .postQuest: return .post
        case .deleteQuest: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getQuest: return nil
        case .postQuest: return nil
        case .deleteQuest: return nil
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getQuest(let request): return .query(request)
        case .postQuest(let request): return .body(request)
        case .deleteQuest(let request): return .query(request)
        }
    }
}
