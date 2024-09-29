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
    
    init(questId: String, missionTitle: String, rewardList: [RewardResponse], status: String, writer: String, image: UIImage? ,logoImageId: String, expireDate: String, score: Int) {
        self.questId = questId
        self.missionTitle = missionTitle
        self.rewardList = rewardList
        self.status = status
        self.writer = writer
        self.image = image
        self.logoImageId = logoImageId
        self.expireDate = expireDate
        self.score = score
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
    }
    
    static let initialData = Quest.init()
    static let mockData1 = Quest.init(questId: UUID().uuidString, missionTitle: "밥먹기", rewardList: [], status: "", writer: "이기욱", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0)
    static let mockData2 = Quest.init(questId: UUID().uuidString, missionTitle: "커피 마시기", rewardList: [], status: "", writer: "이기욱", image: nil, logoImageId: "", expireDate: "2024-12-31", score: 0)
    static let defaultLogoImageId = "IMQU2024092917552786"
}
