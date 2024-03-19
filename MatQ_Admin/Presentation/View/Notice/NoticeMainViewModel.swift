//
//  NoticeMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine
import UIKit

protocol NoticeMainViewModelInput {
    func getNoticeList(target: NoticeTargetType, page: Int) async
}

protocol NoticeMainViewModelOutput {
    var items: [Notice] { get }
    var error: PassthroughSubject<String, Never> { get }
}

final class NoticeMainViewModel: NoticeMainViewModelInput, NoticeMainViewModelOutput, ObservableObject {
    
    private let noticeUseCase: GetNoticeUseCaseInterface
    
    private var noticeList: [Notice] = []
    private var currentPage: Int = 0

    @Published var items: [Notice] = []
    @Published var selectedType: NoticeTargetType = .ALL

    @Published var errorMessage: String = ""
    @Published var showingAlert = false
    
    @Published var viewState: ViewState = .loading

    var error = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    init(noticeUseCase: GetNoticeUseCaseInterface) {
        self.noticeUseCase = noticeUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showingAlert.toggle()
        }.store(in: &cancellables)
    }

    @MainActor
    func getNoticeList(target: NoticeTargetType, page: Int) async {
        await noticeUseCase.getNoticeList(target: target, page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewState = self.items.isEmpty ? .empty : .loaded
                case .failure:
                    self.error.send("Fail to load notices")
                    self.viewState = .empty
                }
            } receiveValue: { [weak self] result in
                if page == 0 {
                    self?.items = []
                    self?.noticeList = []
                }
                for item in result {
                    self?.items.append(item)
                }
                // TODO: 페이지네이션, refresh에는 초기화
                self?.noticeList += result
            }
            .store(in: &cancellables)
    }
}
