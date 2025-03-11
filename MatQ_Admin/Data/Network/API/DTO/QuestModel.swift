//
//  QuestModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/15/24.
//

import Foundation
import UIKit

protocol StringValue {
    var title: String { get }
}

// MARK: - 퀘스트 목록 조회
struct GetQuestRequest: Encodable {
    let page: Int
    let size: Int = 90
    let creatorRole: String = "ADMIN"
    //    let type: String = "REPEAT" //  TODO: 호출 분리하기
}

typealias GetQuestResponse = ResponseWithPage<[GetQuestResponseData]>
struct GetQuestResponseData: Decodable {
    let questId, writer, status, expireDate: String
    let imageId, mainImageId: String?
    let rewardList: [RewardResponse]
    let missionList: [Mission]
    let score: Int
    let type, target: String
    let popularYn: Bool
    
    
    func toDomain(writerImage: UIImage?, mainImage: UIImage?) -> Quest {
        Quest(
            questId: self.questId,
            mission: self.missionList.first ?? .init(content: ""), // 미션 첫번째만 반환
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
/*
 {
   "writer": "일상",
   "imageId": "IMQU2024071520500801",
   "missions": [
     {
       "content": "수학 퀴즈 맞추기",
       "target": "string",
       "quantity": 0,
       "type": "WORDS",
       "quizzes": [
         {
           "question": "1 더하기 3은",
           "hint": "힌트힌트",
           "answers": [
             {
               "content": "4"
             }
           ]
         }
       ]
     }
   ],
   "rewards": [
     {
       "content": "FUN",
       "quantity": 30,
       "type": "XP"
     }
   ],
   "score": 0,
   "expireDate": "2030-12-30",
   "target": "DAILY",
   "type": "REPEAT",
   "mainImageId": "",
   "popularYn": false
 }
 */
// MARK: - 퀘스트 등록
struct PostQuestRequest: Encodable {
    let writer: String
    let imageId: String
    let missions: [Mission]
    let rewards: [Reward]
    let score: Int
    let expireDate: String
    let type: String // NORMAL, REPEAT
    let target: String // NONE, DAILY, WEEKLY, MONTHLY
    var mainImageId: String? = nil
    let popularYn: Bool
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

// MARK: - Mission / Reward / Quiz / Answer
struct Mission: Codable, Hashable {
    let content: String
    let type: String
    var quizzes: [Quiz]? = nil
    
    init(content: String) {
        self.content = content
        self.type = "FREE"
    }
    
    init(content: String, missionType: MissionType, quizzes: [Quiz]) {
        self.content = content
        self.type = missionType.rawValue
        self.quizzes = quizzes
    }
}

struct Reward: Codable {
    let content: String?
    let quantity: Int
    var type: String = "XP"
}

// TODO: 모델 분리?
struct Quiz: Codable, Hashable {
    var question, hint: String
    var answers: [Answer]
}
// TODO: 모델 분리?

struct Answer: Codable, Hashable {
    var content: String
}

// MARK: - Type
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

enum MissionType: String, CaseIterable, Identifiable, StringValue {
    case FREE
    case OX
    case WORDS
    // case NONE // 미사용
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .FREE:
            "사진 인증"
        case .OX:
            "OX"
        case .WORDS:
            "단답형"
        }
    }
}
