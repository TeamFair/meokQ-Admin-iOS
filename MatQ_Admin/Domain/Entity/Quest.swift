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
    let quantity: Int
    let status: String
    let writer: String
    let image: UIImage?
    let logoImageId: String?
    let expireDate: String
    
    init(questId: String, missionTitle: String, quantity: Int, status: String, writer: String, image: UIImage? ,logoImageId: String, expireDate: String) {
        self.questId = questId
        self.missionTitle = missionTitle
        self.quantity = quantity
        self.status = status
        self.writer = writer
        self.image = image
        self.logoImageId = logoImageId
        self.expireDate = expireDate
    }
    
    init(quest: GetQuestResponseImageData) {
        self.questId = quest.questId
        self.missionTitle = quest.missionTitle
        self.quantity = quest.quantity
        self.status = quest.status
        self.writer = quest.writer
        self.image = quest.image
        self.logoImageId = quest.imageId
        self.expireDate = quest.expireDate
    }
    
    init() {
        self.questId = UUID().uuidString
        self.missionTitle = ""
        self.quantity = 50
        self.status = ""
        self.writer = "일상"
        self.image = .testimage
        self.logoImageId = Quest.defaultLogoImageId
        self.expireDate = "2030-12-31"
    }
    
    static let initialData = Quest.init()
    static let mockData1 = Quest.init(questId: UUID().uuidString, missionTitle: "밥먹기", quantity: 50, status: "", writer: "이기욱", image: nil, logoImageId: "", expireDate: "2024-12-31")
    static let mockData2 = Quest.init(questId: UUID().uuidString, missionTitle: "커피 마시기", quantity: 50, status: "", writer: "이기욱", image: nil, logoImageId: "", expireDate: "2024-12-31")
    static let defaultLogoImageId = "IMMA2024072114492808"
}
