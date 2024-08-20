//
//  ChallengeModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Foundation
import UIKit

// MARK: - 챌린지 목록 조회
struct GetChallengeRequest: Encodable {
    let page: Int
    let size: Int = 50
}

typealias GetChallengeResponse = ResponseWithPage<[GetChallengeResponseData]>

struct GetChallengeResponseData: Decodable {
    let challengeId: String
    let userNickName: String?
    let quest: QuestResponse?
    let receiptImageId, status: String
    let createdAt: String
    
    func toDomain(image: UIImage?) -> Challenge {
        return Challenge(challengeId: self.challengeId, userNickName: self.userNickName ?? "불러올 수 없음", quantity: self.quest?.rewards[0].quantity ?? 0, challengeTitle: self.quest?.missions[0].content ?? "불러올 수 없음", receiptImageId: self.receiptImageId, status: self.status, createdAt: self.createdAt, image: image)
    }
}

struct QuestResponse: Decodable {
    let questId: String
    let missions: [MissionResponse]
    let rewards: [RewardResponse]
}

struct MissionResponse: Decodable {
    let content: String
    let quantity: Int
    let type: String
}

struct RewardResponse: Decodable {
    let target: String
    let quantity: Int
    let type: String
}


// MARK: - 챌린지 상태 변경
struct PatchChallengeRequest: Encodable {
    let challengeId: String
    let status: String
}

typealias PatchChallengeResponse = ResponseWithoutData


// MARK: - 챌린지 삭제
struct DeleteChallengeRequest: Encodable {
    let challengeId: String
}

typealias DeleteChallengeResponse = ResponseWithoutData
