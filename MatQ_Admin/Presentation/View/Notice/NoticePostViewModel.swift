//
//  NoticePostViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/9/24.
//

import Combine
import UIKit

protocol NoticePostViewModelInput {
    func postNotice() async
}

protocol NoticePostViewModelOutput {
    var feedback: PassthroughSubject<String, Never> { get }
}

final class NoticePostViewModel: NoticePostViewModelInput, NoticePostViewModelOutput, ObservableObject {
    
    private let noticeUseCase: PostNoticeUseCaseInterface
    
    @Published var target: NoticeTargetType = .ALL
    @Published var title: String = ""
    @Published var content: String = ""
    
    var buttonAble: Bool {
        title != "" && content != ""
    }
    
    @Published var feedbackMessage: String = ""
    @Published var showingErrorAlert = false
    @Published var showingSuccessAlert = false

    var feedback = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(noticeUseCase: PostNoticeUseCaseInterface) {
        self.noticeUseCase = noticeUseCase
        
        feedback.sink { [weak self] isError in
            self?.feedbackMessage = isError
        }.store(in: &cancellables)
    }
    
    @MainActor
    func postNotice() async {
        await noticeUseCase.postNotice(title: title, content: content, target: target)
            .sink { completion in
                switch completion {
                case .finished:
                    self.feedback.send("Success to post notice")
                    self.showingSuccessAlert.toggle()
                case .failure:
                    self.feedback.send("Fail to post notice")
                    self.showingErrorAlert.toggle()
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
}
