//
//  QuestMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Foundation
import Combine
import SwiftUI


protocol QuestMainViewModelInput {
    func getQuestList(page: Int) async
}

protocol QuestMainViewModelOutput {
    var items: [QuestMainViewModelItem] { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class QuestMainViewModel: QuestMainViewModelInput, QuestMainViewModelOutput, ObservableObject {
    private let questUseCase: GetQuestUseCaseInterface
    
    var questList: [Quest] = [Quest.mockData1, Quest.mockData2]
    private var currentPage: Int = 0
    
    @Published var items: [QuestMainViewModelItem] = []
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
    
    
    init(questUseCase: GetQuestUseCaseInterface) {
        self.questUseCase = questUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingAlert = true
        }.store(in: &cancellables)
    }

    func getQuestList(page: Int) {
        viewState = .loading
        questUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = self.items.isEmpty ? .empty : .loaded
                case .failure:
                    self.error.send("Fail to load Quest")
                    self.viewState = .empty
                }
            } receiveValue: { [weak self] result in
                if page == 0 {
                    self?.items = []
                    self?.questList = []
                }
                
                for item in result.map(QuestMainViewModelItem.init) {
                    self?.items.append(item)
                }
                // TODO: 페이지네이션
                self?.questList += result
                self?.viewState = .loaded
            }
            .store(in: &cancellables)
    }
}

struct QuestMainViewModelItem {
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
        self.expireDate = quest.expireDate.timeAgoSinceDate()
        self.logoImage = quest.image
        self.status = quest.status
    }
    
    static var mockData1 = QuestMainViewModelItem.init(quest: .mockData1)
    static var mockData2 = QuestMainViewModelItem.init(quest: .mockData2)
}
