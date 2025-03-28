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
    let size: Int = 70
    let creatorRole: String = "ADMIN"
}

typealias GetQuestResponse = ResponseWithPage<[GetQuestResponseData]>
struct GetQuestResponseData: Decodable {
    let questId, writer, missionTitle, status, expireDate: String
    let imageId, mainImageId: String?
    let rewardList: [RewardResponse]
    let score: Int
    let type, target: String
    let popularYn: Bool
    
    func toDomain(writerImage: UIImage?, mainImage: UIImage?) -> Quest {
        Quest(
            questId: self.questId,
            missionTitle: self.missionTitle,
            rewardList: self.rewardList,
            status: self.status,
            writer: self.writer,
            writerImage: writerImage,
            writerImageId: self.imageId,
            mainImage: mainImage,
            mainImageId: self.mainImageId,
            expireDate: self.expireDate,
            score: self.score,
            type: self.type,
            target: self.target,
            popularYn: self.popularYn
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
    var mainImageId: String? = nil
    let popularYn: Bool
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
    case event
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .normal:
            "일반"
        case .repeat:
            "반복"
        case .event:
            "이벤트"
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
            "일반"
        }
    }
    
    var color: UIColor {
        switch self {
        case .none: .brown
        case .daily: .blue
        case .weekly: .orange
        case .monthly: .red
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
        var mainImageId: String? = nil
        let popularYn: Bool
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
