//
//  NoticeDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/10/24.
//

import Combine
import UIKit

protocol NoticeDetailViewModelInput {
    func deleteNotice() async
}

protocol NoticeDetailViewModelOutput {
    var feedback: PassthroughSubject<String, Never> { get }
}

final class NoticeDetailViewModel: NoticeDetailViewModelInput, NoticeDetailViewModelOutput, ObservableObject {
    
    private let noticeUseCase: DeleteNoticeUseCaseInterface
    
    let notice: Notice
    
    @Published var feedbackMessage: String = ""
    @Published var showingDeleteAlert = false
    @Published var showingErrorAlert = false
    @Published var showingSuccessAlert = false

    var feedback = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(noticeUseCase: DeleteNoticeUseCaseInterface, notice: Notice) {
        self.noticeUseCase = noticeUseCase
        self.notice = notice
        
        feedback.sink { [weak self] isError in
            self?.feedbackMessage = isError
        }.store(in: &cancellables)
    }
    
    @MainActor
    func deleteNotice() async {
        await noticeUseCase.deleteNotice(noticeId: notice.noticeId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.feedback.send("Success to delete notice")
                    self.showingSuccessAlert.toggle()
                case .failure:
                    self.feedback.send("공지 삭제를 실패했습니다.")
                    self.showingErrorAlert.toggle()
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
}
