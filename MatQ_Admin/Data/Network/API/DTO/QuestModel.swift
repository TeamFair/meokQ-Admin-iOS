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
    let type, target: String
    
    func toDomain(image: UIImage?) -> Quest {
        Quest(
            questId: self.questId,
            missionTitle: self.missionTitle,
            rewardList: self.rewardList,
            status: self.status,
            writer: self.writer,
            image: image,
            logoImageId: self.imageId ?? "",
            expireDate: self.expireDate,
            score: self.score,
            type: self.type,
            target: self.target
        )
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
    let type, target: String
}

struct Mission: Encodable {
    let content: String
    let type: String?
    
    init(content: String) {
        self.content = content
        self.type = "FREE"
    }
}

protocol StringValue {
    var title: String { get }
}

enum QuestType: String, CaseIterable, Identifiable, StringValue {
    case normal
    case `repeat`
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .normal:
            "일반"
        case .repeat:
            "반복"
        }
    }
}

enum QuestRepeatTarget: String, CaseIterable, Identifiable, StringValue {
    case daily
    case weekly
    case monthly
    case none
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .daily:
            "일간"
        case .weekly:
            "주간"
        case .monthly:
            "월간"
        case .none:
            "없음"
        }
    }
}

struct Reward: Encodable {
    let content: String?
    let quantity: Int
    let type: String = "XP"
}

typealias PostQuestResponse = ResponseWithoutData

// MARK: - 퀘스트 수정
struct PutQuestRequest: Encodable {
    let questId: String
    let quest: QuestModel
    
    struct QuestModel: Encodable {
        let writer: String
        let imageId: String
        let missions: [Mission]
        let rewards: [Reward]
        let score: Int
        let expireDate: String
        let type: String
        let target: String
    }
}

typealias PutQuestResponse = ResponseWithoutData

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
