//
//  QuestMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Foundation
import Combine
import SwiftUI

final class QuestMainViewModel: ObservableObject {
    
    var questList: [Quest] = [Quest.mockData1, Quest.mockData2]

    @Published var items: [QuestMainViewModelItem] = [.mockData1, .mockData2]
    @Published var viewState: ViewState = .loaded

    
    enum ViewState {
        case empty
        case loading
        case loaded
    }
}

struct QuestMainViewModelItem {
    let questId: String
    let questTitle: String
    let logoImageId: String
    let logoImage: UIImage?
    let expireDate: String
    
    init(questId: String, questTitle: String, logoImageId: String, logoImage: UIImage?, expireDate: String) {
        self.questId = questId
        self.questTitle = questTitle
        self.logoImageId = logoImageId
        self.logoImage = logoImage
        self.expireDate = expireDate
    }
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.questTitle = quest.missionTitle
        self.logoImageId = quest.logoImageId ?? "" // TODO: 수정
        self.expireDate = quest.expireDate
        self.logoImage = nil // TODO: 수정
    }
    
    static var mockData1 = QuestMainViewModelItem.init(quest: .mockData1)
    static var mockData2 = QuestMainViewModelItem.init(quest: .mockData2)
}
