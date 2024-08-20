//
//  ChallengeTarget.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Alamofire
import Foundation

enum ChallengeTarget {
    case getChallenge(GetChallengeRequest)
    case patchChallenge(PatchChallengeRequest)
    case deleteChallenge(DeleteChallengeRequest)
}

extension ChallengeTarget: TargetType {
    var baseURL: String {
        switch self {
        case .getChallenge, .patchChallenge: return URL.makeEndPoint(.admin(endPoint: "report"))
        case .deleteChallenge: return URL.makeEndPoint(.admin(endPoint: ""))
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getChallenge: return .get
        case .patchChallenge: return .patch
        case .deleteChallenge: return .delete
        }
    }
    
    var path: String? {
        switch self {
        case .getChallenge: return nil
        case .patchChallenge: return nil
        case .deleteChallenge(let request): return request.challengeId
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getChallenge(let request): return .query(request)
        case .patchChallenge(let request): return .query(request)
        case .deleteChallenge: return .query(.none)
        }
    }
}
