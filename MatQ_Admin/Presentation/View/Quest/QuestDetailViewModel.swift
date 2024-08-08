//
//  QuestDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Combine
import UIKit

final class QuestDetailViewModel: ObservableObject {
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
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var photosPickerItem: PhotosPickerItem?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(viewType: ViewType, questDetail: Quest, postQuestUseCase: PostQuestUseCaseInterface, deleteQuestUseCase: DeleteQuestUseCaseInterface) {
        self.viewType = viewType
        self.questDetail = questDetail
        self.items = QuestDetailViewModelItem(quest: questDetail)
        self.editedItems = QuestDetailViewModelItem(quest: questDetail)
        self.postQuestUseCase = postQuestUseCase
        self.deleteQuestUseCase = deleteQuestUseCase
    }
    
    let postQuestUseCase: PostQuestUseCaseInterface
    let deleteQuestUseCase: DeleteQuestUseCaseInterface
    
    func createData(data: QuestDetailViewModelItem) {
        guard let imageId = data.imageId else {
            // TODO: 에러처리
            return
        }
        postQuestUseCase.postQuest(writer: data.writer, imageId: imageId, missionTitle: data.questTitle, quantity: Int(data.xpCount)!, expireDate: data.expireDate)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "퀘스트 추가 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "퀘스트 추가 성공"
                self?.alertMessage = "퀘스트가 성공적으로 추가되었습니다"
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    func deleteData(questId: String, type: QuestDeleteType) {
        deleteQuestUseCase.deleteQuest(questId: questId, type: type)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "퀘스트 삭제 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "퀘스트 삭제 성공"
                self?.alertMessage = "퀘스트가 성공적으로 삭제되었습니다"
                self?.showAlert = true
            }
            .store(in: &subscriptions)
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

enum QuestDeleteType: String, Encodable {
    case hard
    case soft
}
