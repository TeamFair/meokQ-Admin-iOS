//
//  GetQuest.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/15/24.
//

import Foundation
import UIKit

// MARK: - 퀘스트 목록 조회
struct GetQuestRequest: Encodable {
    let page: Int
    let size: Int = 10
    let creatorRole: String = "ADMIN"
//    let searchDto: SearchDTO
}

//struct SearchDTO: Encodable {
//    let creatorRole: String = "ADMIN"
//}

typealias GetQuestResponse = ResponseWithPage<[GetQuestResponseData]>
struct GetQuestResponseData: Decodable {
    let questId: String
    let writer: String
    let marketId: String?
    let quantity: Int
    let missionTitle: String
    let status: String
    let expireDate: String
    let imageId: String?
}

// MARK: - 퀘스트 등록
struct PostQuestRequest: Encodable {
    let writer: String
    let imageId: String = "IMMA2024072114492808"
    // let imageId: String = "IMQU2024071520500801" //coocker
    let missions: [Mission]
    let rewards: [Reward]
    let expireDate: String
}

struct Mission: Encodable {
    let content: String
    let quantity: Int = 0
    let type: String = "FREE"
}

struct Reward: Encodable {
    let target: String = ""
    let quantity: Int
    let type: String = "XP"
}

typealias PostQuestResponse = ResponseWithoutData

// MARK: - 퀘스트 삭제
struct DeleteQuestRequest: Encodable {
    let questId: String
}

typealias DeleteQuestResponse = ResponseWithoutData
