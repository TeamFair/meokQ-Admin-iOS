//
//  ManageDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Foundation
import UIKit

final class ManageDetailViewModel: ObservableObject {
    
    private let challengeDetail: Quest
    
    let items: ManageDetailViewModelItem
    
    // 챌린지 철회&삭제 Alert 관련
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    
    enum ActiveAlertType: Identifiable {
        case delete
        case recovery
        case result
        
        var id: Int {
            switch self {
            case .delete:
                return 1
            case .recovery:
                return 2
            case .result:
                return 3
            }
        }
    }
    
    init(challengeDetail: Quest) {
        self.challengeDetail = challengeDetail
        self.items = ManageDetailViewModelItem(quest: challengeDetail)
    }
    
    func recoveryChallenge(challengeId: String) {
        // TODO: API 연결
    }
    
    func deleteChallenge(challengeId: String) {
        // TODO: API 연결
    }
}

struct ManageDetailViewModelItem: Equatable {
    let questId: String
    var questTitle: String
    var xpCount: String
    var writer: String
    var expireDate: String
    let imageId: String?
    var questImage: UIImage?
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.questTitle = quest.missionTitle
        self.xpCount = String(quest.quantity)
        self.writer = quest.writer
        self.expireDate = quest.expireDate
        self.imageId = quest.logoImageId
        self.questImage = quest.image
    }
}
