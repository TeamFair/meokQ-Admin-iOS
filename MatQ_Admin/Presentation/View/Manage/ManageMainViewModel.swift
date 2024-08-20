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
    private let getChallengeUseCase: GetChallengeUseCaseInterface

    var challengeList: [Challenge] = []
    private var currentPage: Int = 0
    
    @Published var items: [ManageMainViewModelItem] = []
    @Published var errorMessage: String = ""
    @Published var showAlert = false
    @Published var viewState: ViewState = .loaded
    @Published var activeAlertType: ActiveAlertType?

    @AppStorage("port") var port = "9090"
    @Published var portText = ""
    
    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(getChallengeUseCase: GetChallengeUseCaseInterface) {
        self.getChallengeUseCase = getChallengeUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.activeAlertType = .networkError
            self?.showAlert = true
        }.store(in: &cancellables)
    }
    
    func getReportedList(page: Int) {
        viewState = .loading
        getChallengeUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = self.items.isEmpty ? .empty : .loaded
                case .failure(let err):
                    self.error.send(err.localizedDescription)
                    self.viewState = .empty
                }
            } receiveValue: { [weak self] result in
                if page == 0 {
                    self?.items = []
                    self?.challengeList = []
                }
                for item in result.map(ManageMainViewModelItem.init) {
                    self?.items.append(item)
                }

                // TODO: 페이지네이션
                self?.challengeList += result
                self?.viewState = .loaded
            }
            .store(in: &cancellables)
    }
}

extension ManageMainViewModel {
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    enum ActiveAlertType: Identifiable {
        case portchange
        case networkError
        
        var id: Int {
            switch self {
            case .portchange:
                return 1
            case .networkError:
                return 2
            }
        }
    }
}

struct ManageMainViewModelItem {
    let challengeId: String
    let questTitle: String
    let imageId: String?
    let image: UIImage?
    let status: String
    let createdAt: String
    
    init(challengeId: String, questTitle: String, imageId: String?, image: UIImage?, status: String, createdAt: String) {
        self.challengeId = challengeId
        self.questTitle = questTitle
        self.imageId = imageId
        self.image = image
        self.status = status
        self.createdAt = createdAt
    }
    
    init(challenge: Challenge) {
        self.challengeId = challenge.challengeId
        self.questTitle = challenge.challengeTitle
        self.imageId = challenge.receiptImageId
        self.image = challenge.image
        self.status = challenge.status
        self.createdAt = challenge.createdAt
    }
}
