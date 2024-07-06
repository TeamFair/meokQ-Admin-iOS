//
//  Quest.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import UIKit

// TODO: logoImageId 서버 수정시 반영
struct Quest {
    let questId: String
    let missionTitle: String
    let rewardTitle: String
    let status: String
    let publisher: String?
    let logoImageId: String?
    let expireDate: String
    
    init(questId: String, missionTitle: String, rewardTitle: String, status: String ,publisher: String?, logoImageId: String?, expireDate: String) {
        self.questId = questId
        self.missionTitle = missionTitle
        self.rewardTitle = rewardTitle
        self.status = status
        self.publisher = publisher
        self.logoImageId = logoImageId
        self.expireDate = expireDate
    }
    
    init() {
        self.questId = UUID().uuidString
        self.missionTitle = ""
        self.rewardTitle = "0"
        self.status = ""
        self.publisher = ""
        self.logoImageId = ""
        self.expireDate = "2024/12/31"
    }
    
    static let initialData = Quest.init()
    static let mockData1 = Quest.init(questId: UUID().uuidString, missionTitle: "밥먹기", rewardTitle: "50", status: "", publisher: "이기욱", logoImageId: nil, expireDate: "24/12/31")
    static let mockData2 = Quest.init(questId: UUID().uuidString, missionTitle: "커피 마시기", rewardTitle: "50", status: "", publisher: "이기욱", logoImageId: nil, expireDate: "24/12/31")
}
