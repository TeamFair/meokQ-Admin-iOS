//
//  Quest.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import UIKit

struct Quest {
    let questId: String
    let mission: Mission
    let rewardList: [RewardResponse]
    let status: String
    let writer: String
    var writerImage: UIImage?
    let writerImageId: String?
    var mainImage: UIImage?
    let mainImageId: String?
    let expireDate: String
    let score: Int
    let type: String
    let target: String
    let popularYn: Bool
    
    init(
        questId: String,
        mission: Mission,
        rewardList: [RewardResponse],
        status: String,
        writer: String,
        writerImage: UIImage?,
        writerImageId: String?,
        mainImage: UIImage?,
        mainImageId: String?,
        expireDate: String,
        score: Int,
        type: String,
        target: String,
        popularYn: Bool
    ) {
        self.questId = questId
        self.mission = mission
        self.rewardList = rewardList
        self.status = status
        self.writer = writer
        self.writerImage = writerImage
        self.writerImageId = writerImageId
        self.mainImage = mainImage
        self.mainImageId = mainImageId
        self.expireDate = expireDate
        self.score = score
        self.type = type
        self.target = target
        self.popularYn = popularYn
    }
    
    init() {
        self.questId = UUID().uuidString
        self.mission = .init(content: "")
        self.rewardList = []
        self.status = ""
        self.writer = "일상"
        self.writerImage = .testimage
        self.writerImageId = Quest.defaultLogoImageId
        self.mainImage = nil
        self.mainImageId = nil
        self.expireDate = "2030-12-31"
        self.score = 0
        self.type = "NORMAL"
        self.target = "NONE"
        self.popularYn = false
    }
    
    static let initialData = Quest.init()
    
    static let mockOXData = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "퀴즈", missionType: .OX, quizzes: [.init(question: "1+4는?", hint: "오~", answers: [.init(content: "5")])]),
        rewardList: [.init(
            content: "strength",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 선생님",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "normal",
        target: "none",
        popularYn: false
    )
    static let mockData1 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "베트남 음식 도전하기"),
        rewardList: [.init(
            content: "strength",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 선생님",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "normal",
        target: "none",
        popularYn: false
    )
    static let mockData2 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "바닐라 라떼 마시기"),
        rewardList: [.init(
            content: "fun",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "daily",
        popularYn: false
    )
    static let mockData3 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "나무 사진 찍기"),
        rewardList: [.init(
            content: "intellect",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "weekly",
        popularYn: false
    )
    static let mockData4 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "태국 음식 도전하기"),
        rewardList: [
            .init(
                content: "charm",
                quantity: 10,
                type: "XP"
            ),
            .init(
                content: "fun",
                quantity: 10,
                type: "XP"
            )
        ],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "monthly",
        popularYn: false
    )
    static let mockData11 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "베트남 음식 도전하기"),
        rewardList: [.init(
            content: "strength",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 선생님",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "normal",
        target: "none",
        popularYn: false
    )
    static let mockData22 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "바닐라 라떼 마시기"),
        rewardList: [.init(
            content: "fun",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "daily",
        popularYn: false
    )
    static let mockData33 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "나무 사진 찍기"),
        rewardList: [.init(
            content: "intellect",
            quantity: 10,
            type: "XP"
        )],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "weekly",
        popularYn: false
    )
    static let mockData44 = Quest.init(
        questId: UUID().uuidString,
        mission: .init(content: "태국 음식 도전하기"),
        rewardList: [
            .init(
                content: "charm",
                quantity: 10,
                type: "XP"
            ),
            .init(
                content: "fun",
                quantity: 10,
                type: "XP"
            )
        ],
        status: "",
        writer: "일상 요리사",
        writerImage: nil,
        writerImageId: "",
        mainImage: nil,
        mainImageId: "",
        expireDate: "2024-12-31",
        score: 0,
        type: "repeat",
        target: "monthly",
        popularYn: false
    )
    static let mockDataList = [mockData1, mockData2, mockData3, mockData4, mockData11, mockData22, mockData33, mockData44]
    static let defaultLogoImageId = "IMQU2024092917552786"
}
