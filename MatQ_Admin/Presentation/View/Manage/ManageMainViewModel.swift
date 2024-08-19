//
//  ManageMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import SwiftUI

protocol ManageMainViewModelInput {
    func getReportedList(page: Int) async
}

protocol ManageMainViewModelOutput {
    var items: [ManageMainViewModelItem] { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class ManageMainViewModel: ManageMainViewModelInput, ManageMainViewModelOutput, ObservableObject {
    
    var questList: [Quest] = [Quest.mockData1, Quest.mockData2]
    private var currentPage: Int = 0
    
    @Published var items: [ManageMainViewModelItem] = []
    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    @Published var viewState: ViewState = .loaded
    
    @AppStorage("port") var port = "9090"
    @Published var portText = ""
    
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingAlert.toggle()
        }.store(in: &cancellables)
    }
    
    func getReportedList(page: Int) {
        self.items = [.mockData1]
    }
}

struct ManageMainViewModelItem {
    let questId: String
    let questTitle: String
    let logoImageId: String?
    let logoImage: UIImage?
    let status: String
    let expireDate: String
    
    init(questId: String, questTitle: String, logoImageId: String, logoImage: UIImage?, status: String, expireDate: String) {
        self.questId = questId
        self.questTitle = questTitle
        self.logoImageId = logoImageId
        self.logoImage = logoImage
        self.status = status
        self.expireDate = expireDate
    }
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.questTitle = quest.missionTitle
        self.logoImageId = quest.logoImageId
        self.expireDate = quest.expireDate
        self.logoImage = quest.image
        self.status = quest.status
    }
    
    static var mockData1 = ManageMainViewModelItem.init(quest: .mockData1)
    static var mockData2 = ManageMainViewModelItem.init(quest: .mockData2)
}
