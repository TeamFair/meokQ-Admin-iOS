//
//  QuestDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import Combine
import UIKit
import _PhotosUI_SwiftUI

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
    
    // 퀘스트 추가&삭제 Alert 관련
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    @Published var selectedDeleteType: QuestDeleteType = .hard
    
    enum ActiveAlertType: Identifiable {
        case delete
        case result
        
        var id: Int {
            switch self {
            case .delete:
                return 1
            case .result:
                return 2
            }
        }
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var photosPickerItem: PhotosPickerItem? {
        didSet {
            Task {
                if let imageDataTransferable = try? await photosPickerItem?.loadTransferable(type: ImageDataTransferable.self) {
                    self.editedItems.questImage = imageDataTransferable.uiImage
                    self.editedItems.imageId = nil
                }
            }
        }
    }

    init(viewType: ViewType, questDetail: Quest, postQuestUseCase: PostQuestUseCaseInterface, putQuestUseCase: PutQuestUseCaseInterface, deleteQuestUseCase: DeleteQuestUseCaseInterface) {
        self.viewType = viewType
        self.questDetail = questDetail
        self.items = QuestDetailViewModelItem(quest: questDetail)
        self.editedItems = QuestDetailViewModelItem(quest: questDetail)
        self.postQuestUseCase = postQuestUseCase
        self.putQuestUseCase = putQuestUseCase
        self.deleteQuestUseCase = deleteQuestUseCase
    }
    
    let postQuestUseCase: PostQuestUseCaseInterface
    let putQuestUseCase: PutQuestUseCaseInterface
    let deleteQuestUseCase: DeleteQuestUseCaseInterface
    
    func createData(data: QuestDetailViewModelItem) {
        let rewardList = data.toRewardList()
       
        postQuestUseCase.execute(writer: data.writer, image: data.questImage, imageId: data.imageId, missionTitle: data.questTitle, rewardList: rewardList, score: data.score, expireDate: data.expireDate)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "퀘스트 추가 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "퀘스트 추가 성공"
                self?.alertMessage = "퀘스트가 성공적으로 추가되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    func modifyData(_ data: QuestDetailViewModelItem, imageUpdated: Bool) {
        putQuestUseCase.execute(questId: data.questId, writer: data.writer, image: data.questImage, imageId: data.imageId, missionTitle: data.questTitle, rewardList: data.toRewardList(), score: data.score, expireDate: data.expireDate, imageUpdated: imageUpdated)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "퀘스트 수정 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "퀘스트 수정 성공"
                self?.alertMessage = "퀘스트가 성공적으로 수정되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    func deleteData(questId: String, type: QuestDeleteType) {
        deleteQuestUseCase.execute(questId: questId, type: type)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "퀘스트 삭제 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "퀘스트 삭제 성공"
                self?.alertMessage = "퀘스트가 성공적으로 삭제되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
}

struct QuestDetailViewModelItem: Equatable {
    let questId: String
    var questTitle: String
    var strengthXP: Int
    var intellectXP: Int
    var funXP: Int
    var charmXP: Int
    var sociabilityXP: Int
    var writer: String
    var score: Int
    var expireDate: String
    var imageId: String?
    var questImage: UIImage?
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.questTitle = quest.missionTitle
        self.strengthXP = quest.rewardList.first(where: { $0.content == "STRENGTH" })?.quantity ?? 0
        self.intellectXP = quest.rewardList.first(where: { $0.content == "INTELLECT" })?.quantity ?? 0
        self.funXP = quest.rewardList.first(where: { $0.content == "FUN" })?.quantity ?? 0
        self.charmXP = quest.rewardList.first(where: { $0.content == "CHARM" })?.quantity ?? 0
        self.sociabilityXP = quest.rewardList.first(where: { $0.content == "SOCIABILITY" })?.quantity ?? 0
        self.writer = quest.writer
        self.score = quest.score
        self.expireDate = quest.expireDate.timeAgoSinceDate()
        self.imageId = quest.logoImageId
        self.questImage = quest.image
    }
    
    func toRewardList() -> [Reward] {
        let xpTypes: [(content: String, value: Int)] = [
            ("STRENGTH", self.strengthXP),
            ("INTELLECT", self.intellectXP),
            ("FUN", self.funXP),
            ("CHARM", self.charmXP),
            ("SOCIABILITY", self.sociabilityXP)
        ]

        return xpTypes.compactMap { (content, value) in
            value != 0 ? Reward(content: content, quantity: value) : nil
        }
    }
}
