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
    case putQuest(PutQuestRequest)
    case deleteQuest(DeleteQuestRequest)
}

extension QuestTarget: TargetType {
    var baseURL: String {
        switch self {
        case .getQuest, .postQuest: return URL.makeEndPoint(.admin(endPoint: "quest"))
        case .deleteQuest(let request): return URL.makeEndPoint(.admin(endPoint: "quest/\(request.deleteType.rawValue)"))
        case .putQuest: return URL.makeEndPoint(.admin(endPoint: "quest/"))
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getQuest: return .get
        case .postQuest: return .post
        case .putQuest: return .put
        case .deleteQuest: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getQuest: return nil
        case .postQuest: return nil
        case .putQuest(let request): return request.questId
        case .deleteQuest: return nil
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getQuest(let request): return .query(request)
        case .postQuest(let request): return .body(request)
        case .putQuest(let request): return .body(request.quest)
        case .deleteQuest(let request): return .query(request.questId)
        }
    }
}
