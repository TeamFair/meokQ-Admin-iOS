//
//  QuestDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Combine
import UIKit

final class QuestDetailViewModel: ObservableObject {
    /// 뷰 >> 뷰모델  입력
    enum Input {
        case createData(QuestDetailViewModelItem)
        case deleteData(String)
        case dismiss
    }
    
    /// 뷰모델  >>  뷰 출력
    enum Output {
        case createSuccess(message: String) // 추가 성공 이벤트
        case createFail(error: Error) // 추가 실패 이벤트
        case deleteSuccess(message: String) // 삭제 성공 이벤트
        case deleteFail(error: Error) // 삭제 실패 이벤트
        case dismiss
    }
    
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
    
    let viewType: ViewType
    private let questDetail: Quest
    
    let items: QuestDetailViewModelItem
    @Published var editedItems: QuestDetailViewModelItem
    
    var error = PassthroughSubject<String, Never>()
    @Published var showAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var errorMessage: String = ""
    
    let output: PassthroughSubject<Output, Never> = .init()
    var subscriptions = Set<AnyCancellable>()
    
    init(viewType: ViewType, questDetail: Quest, postQuestUseCase: PostQuestUseCaseInterface, deleteQuestUseCase: DeleteQuestUseCaseInterface) {
        self.viewType = viewType
        self.questDetail = questDetail
        self.items = QuestDetailViewModelItem(quest: questDetail)
        self.editedItems = QuestDetailViewModelItem(quest: questDetail)
        self.postQuestUseCase = postQuestUseCase
        self.deleteQuestUseCase = deleteQuestUseCase
        
        error.sink { [weak self] errorMessage in
            self?.errorMessage = errorMessage
            self?.showAlert.toggle()
        }.store(in: &subscriptions)
    }
    
    let postQuestUseCase: PostQuestUseCaseInterface
    let deleteQuestUseCase: DeleteQuestUseCaseInterface
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .createData(let data):
                createData(data: data)
            case .deleteData(let id):
                deleteData(questId: id)
            case .dismiss:
                dismissView()
            }
        }
        .store(in: &subscriptions)
        
        return output.eraseToAnyPublisher()
    }
    
    // 의존성 주입 받은 서비스에서 발생한 추가 이벤트를 전달 받는 메서드
    private func createData(data: QuestDetailViewModelItem) {
        guard let imageId = data.imageId else { return }
        postQuestUseCase.postQuest(writer: data.writer, imageId: imageId, missionTitle: data.questTitle, quantity: Int(data.xpCount)!, expireDate: data.expireDate)
            .sink { [weak self] completion in
                // 데이터 추가 실패시
                if case .failure(let error) = completion {
                    self?.output.send(.createFail(error: error))
                }
            } receiveValue: { [weak self] _ in
                self?.output.send(.createSuccess(message: "퀘스트가 성공적으로 추가되었습니다"))
                // self?.output.send(.dismiss)
            }
            .store(in: &subscriptions)
    }
    
    // 의존성 주입 받은 서비스에서 발생한 삭제 이벤트를 전달 받는 메서드
    private func deleteData(questId: String) {
        deleteQuestUseCase.deleteQuest(questId: questId)
            .sink { [weak self] completion in
                // 데이터 삭제 실패시
                if case .failure(let error) = completion {
                    self?.output.send(.deleteFail(error: error))
                }
            } receiveValue: { [weak self] _ in
                self?.output.send(.deleteSuccess(message: "퀘스트가 성공적으로 삭제되었습니다"))
                // self?.output.send(.dismiss)
            }
            .store(in: &subscriptions)
    }
    
    private func dismissView() {
        self.output.send(.dismiss)
    }
}

struct QuestDetailViewModelItem: Equatable {
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
