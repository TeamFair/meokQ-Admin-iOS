//
//  Quest.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import UIKit

struct Quest {
    let questId: String
    let missionTitle: String
    let rewardList: [RewardResponse]
    let status: String
    let writer: String
    var image: UIImage?
    let logoImageId: String?
    let expireDate: String
    let score: Int
    let type: String
    let target: String
    
    init(
        questId: String,
        missionTitle: String,
        rewardList: [RewardResponse],
        status: String,
        writer: String,
        image: UIImage? ,
        logoImageId: String,
        expireDate: String,
        score: Int,
        type: String,
        target: String
    ) {
        self.questId = questId
        self.missionTitle = missionTitle
        self.rewardList = rewardList
        self.status = status
        self.writer = writer
        self.image = image
        self.logoImageId = logoImageId
        self.expireDate = expireDate
        self.score = score
        self.type = type
        self.target = target
    }
    
    init() {
        self.questId = UUID().uuidString
        self.missionTitle = ""
        self.rewardList = []
        self.status = ""
        self.writer = "일상"
        self.image = .testimage
        self.logoImageId = Quest.defaultLogoImageId
        self.expireDate = "2030-12-31"
        self.score = 0
        self.type = "NORMAL"
        self.target = "NONE"
    }
    
    static let initialData = Quest.init()
    static let mockData1 = Quest.init(questId: UUID().uuidString, missionTitle: "베트남 음식 도전하기", rewardList: [.init(content: "strength", quantity: 10, type: "XP")], status: "", writer: "일상 선생님", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "normal", target: "none")
    static let mockData2 = Quest.init(questId: UUID().uuidString, missionTitle: "바닐라 라떼 마시기", rewardList: [.init(content: "fun", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "daily")
    static let mockData3 = Quest.init(questId: UUID().uuidString, missionTitle: "나무 사진 찍기", rewardList: [.init(content: "intellect", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "weekly")
    static let mockData4 = Quest.init(questId: UUID().uuidString, missionTitle: "태국 음식 도전하기", rewardList: [.init(content: "charm", quantity: 10, type: "XP"), .init(content: "fun", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "monthly")
    static let mockData11 = Quest.init(questId: UUID().uuidString, missionTitle: "베트남 음식 도전하기", rewardList: [.init(content: "strength", quantity: 10, type: "XP")], status: "", writer: "일상 선생님", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "normal", target: "none")
    static let mockData22 = Quest.init(questId: UUID().uuidString, missionTitle: "바닐라 라떼 마시기", rewardList: [.init(content: "fun", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "daily")
    static let mockData33 = Quest.init(questId: UUID().uuidString, missionTitle: "나무 사진 찍기", rewardList: [.init(content: "intellect", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "weekly")
    static let mockData44 = Quest.init(questId: UUID().uuidString, missionTitle: "태국 음식 도전하기", rewardList: [.init(content: "charm", quantity: 10, type: "XP"), .init(content: "fun", quantity: 10, type: "XP")], status: "", writer: "일상 요리사", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0, type: "repeat", target: "monthly")
    static let mockDataList = [mockData1, mockData2, mockData3, mockData4, mockData11, mockData22, mockData33, mockData44]
    static let defaultLogoImageId = "IMQU2024092917552786"
}
