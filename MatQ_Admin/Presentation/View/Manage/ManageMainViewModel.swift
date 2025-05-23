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
    var error: AnyPublisher<String, Never> { get }
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

    @AppStorage("port") var port = "8880"
    @Published var portText = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let errorSubject = CurrentValueSubject<String, Never>("")
    
    var error: AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    init(getChallengeUseCase: GetChallengeUseCaseInterface) {
        self.getChallengeUseCase = getChallengeUseCase
        
        errorSubject
            .sink { [weak self] errorMessage in
                if !errorMessage.isEmpty {
                    self?.errorMessage = errorMessage
                    self?.activeAlertType = .networkError
                    self?.showAlert = true
                }
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
        errorSubject.send(error.message)
        viewState = .empty
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
