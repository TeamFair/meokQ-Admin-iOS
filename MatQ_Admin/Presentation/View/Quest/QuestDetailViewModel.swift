//
//  QuestDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Combine
import Foundation
import UIKit

final class QuestDetailViewModel: ObservableObject {
    
    enum ViewType {
        case publish
        case edit
        
        var title: String {
            switch self {
            case .publish:
                "퀘스트 생성"
            case .edit:
                "퀘스트 수정"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .publish:
                "생성"
            case .edit:
                "수정"
            }
        }
    }

    // MARK: Input
    let viewType: ViewType
    private let questDetail: Quest
    
    let items: QuestDetailViewModelItem
    @Published var editedItems: QuestDetailViewModelItem

    init(viewType: ViewType, questDetail: Quest) {
        self.viewType = viewType
        self.questDetail = questDetail
        self.items = QuestDetailViewModelItem(quest: questDetail)
        self.editedItems = QuestDetailViewModelItem(quest: questDetail)
    }
}

struct QuestDetailViewModelItem: Equatable {
    let questId: String
    var questTitle: String
    var xpCount: String
    var publisher: String
    var expireDate: String
    var questImage: UIImage?
    
    // TODO: 변경
    init(quest: Quest) {
        self.questId = quest.questId
        self.questTitle = quest.missionTitle
        self.xpCount = quest.rewardTitle
        self.publisher = quest.publisher ?? ""
        self.expireDate = quest.expireDate
        self.questImage = UIImage.testimage //quest.logoImageId
    }
}
