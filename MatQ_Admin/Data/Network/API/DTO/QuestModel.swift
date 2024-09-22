//
//  QuestModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/15/24.
//

import Foundation
import UIKit

// MARK: - 퀘스트 목록 조회
struct GetQuestRequest: Encodable {
    let page: Int
    let size: Int = 50
    let creatorRole: String = "ADMIN"
}

typealias GetQuestResponse = ResponseWithPage<[GetQuestResponseData]>
struct GetQuestResponseData: Decodable {
    let questId, writer, missionTitle, status, expireDate: String
    let imageId: String?
    let rewardList: [RewardResponse]
    let score: Int
    
    func toDomain(image: UIImage?) -> Quest {
        Quest(questId: self.questId, missionTitle: self.missionTitle, rewardList: self.rewardList, status: self.status, writer: self.writer, image: image, logoImageId: self.imageId ?? "", expireDate: self.expireDate, score: self.score)
    }
}

// MARK: - 퀘스트 등록
struct PostQuestRequest: Encodable {
    let writer: String
    let imageId: String
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
}

struct Mission: Encodable {
    let content: String
    let quantity: Int = 0
    let type: String = "FREE"
}

struct Reward: Encodable {
    let content: String?
    let quantity: Int
    let type: String = "XP"
}

typealias PostQuestResponse = ResponseWithoutData

// MARK: - 퀘스트 삭제
struct DeleteQuestRequest: Encodable {
    let questId: QuestId
    let deleteType: QuestDeleteType
    
    struct QuestId: Encodable {
        let questId: String
    }
}

typealias DeleteQuestResponse = ResponseWithoutData


enum QuestDeleteType: String, Encodable {
    case hard
    case soft
}
