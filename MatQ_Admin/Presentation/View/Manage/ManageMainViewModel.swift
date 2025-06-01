//
//  ManageMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import SwiftUI

protocol ManageMainViewModelInput {
    func getReportedList(page: Int)
}

protocol ManageMainViewModelOutput {
    var items: [ManageMainViewModelItem] { get }
    var alertPublisher: PassthroughSubject<AlertItem, Never> { get }
}

final class ManageMainViewModel: ManageMainViewModelInput, ManageMainViewModelOutput, ObservableObject {
    private let getChallengeUseCase: GetChallengeUseCaseInterface
    
    var challengeList: [Challenge] = []
    private var currentPage: Int = 0
    
    @Published var items: [ManageMainViewModelItem] = []
    
    @Published var showAlert = false
    @Published var alertItem: AlertItem?
    var alertPublisher = PassthroughSubject<AlertItem, Never>()
    
    @Published var showPortSheet = false

    @Published var viewState: ViewState = .loaded
    
    private var cancellables = Set<AnyCancellable>()
    
    init(getChallengeUseCase: GetChallengeUseCaseInterface) {
        self.getChallengeUseCase = getChallengeUseCase
        bind()
    }
    
    private func bind() {
        alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                self?.alertItem = alert
                self?.showAlert = true
            }
            .store(in: &cancellables)
    }
    
    func getReportedList(page: Int) {
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        getChallengeUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .mapError { [weak self] error -> NetworkError in
                self?.handleError(error)
                return error
            }
            .catch { _ in Just([]) }
            .scan([]) { currentItems, newItems -> [ManageMainViewModelItem] in
                self.challengeList += newItems
                
                if page == 0 {
                    return newItems.map(ManageMainViewModelItem.init)
                } else {
                    return currentItems + newItems.map(ManageMainViewModelItem.init)
                }
            }
            .sink(receiveValue: { [weak self] newItems in
                self?.items = newItems
                self?.viewState = newItems.isEmpty ? .empty : .loaded
            })
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NetworkError) {
        alertPublisher.send(AlertStateFactory.simple(title: "신고된 목록 조회 실패", message: error.message))
        viewState = .empty
    }
    
    func showPortChangeSheet() {
        showPortSheet = true
    }
    
    func onPortChanged() {
        getReportedList(page: 0)
    }
}

extension ManageMainViewModel {
    enum ViewState {
        case empty
        case loading
        case loaded
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
