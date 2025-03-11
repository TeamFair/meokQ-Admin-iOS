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
    
    @Published var expandApprovalQuizType: Bool = false
    
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
    
    @Published var photosPickerItemForWriterImage: PhotosPickerItem? {
        didSet {
            Task {
                if let imageDataTransferable = try? await photosPickerItemForWriterImage?.loadTransferable(type: ImageDataTransferable.self) {
                    self.editedItems.writerImage = imageDataTransferable.uiImage
                    self.editedItems.writerImageId = nil
                }
            }
        }
    }
    
    @Published var photosPickerItemForMainImage: PhotosPickerItem? {
        didSet {
            Task {
                if let imageDataTransferable = try? await photosPickerItemForMainImage?.loadTransferable(type: ImageDataTransferable.self) {
                    self.editedItems.mainImage = imageDataTransferable.uiImage
                    self.editedItems.mainImageId = nil
                }
            }
        }
    }
    
    var isPrimaryButtonDisabled: Bool {
        editedItems.missionTitle.isEmpty || editedItems.missionTitle.count > 16 || ((editedItems.strengthXP + editedItems.intellectXP + editedItems.charmXP + editedItems.sociabilityXP + editedItems.funXP) == 0)
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
    
    private func createData(data: QuestDetailViewModelItem) {
        // 타입이 일반이면 >> 타겟도 일반으로 저장
        let request: PostQuestRequestModel = QuestRequestMapper.map(data: data)
        postQuestUseCase.execute(
            request: request,
            image: data.writerImage,
            mainImage: data.mainImage
        )
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
    
    private func modifyData(_ data: QuestDetailViewModelItem, imageUpdated: Bool, mainImageUpdated: Bool) {
        // 타입이 일반이면 >> 타겟도 일반으로 저장
        let request: PutQuestRequestModel = QuestRequestMapper.map(data: data)
        putQuestUseCase.execute(
            request: request,
            image: data.writerImage,
            mainImage: data.mainImage,
            imageUpdated: imageUpdated,
            mainImageUpdated: mainImageUpdated
        )
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
    
    func onPrimaryButtonTap() {
        if viewType == .edit {
            let imageUpdated = editedItems.writerImage != items.writerImage // 이미지가 변경되었는지 확인
            let mainImageUpdated = editedItems.mainImage != items.mainImage // 메인이미지가 변경되었는지 확인
            
            modifyData(editedItems, imageUpdated: imageUpdated, mainImageUpdated: mainImageUpdated)
        } else if viewType == .publish {
            createData(data: editedItems)
        }
    }
    
    func onDeleteButtonTap(type: QuestDeleteType) {
        selectedDeleteType = type
        activeAlertType = .delete
        showAlert = true
    }
    
    func removeQuiz(at idx: Int) {
        if editedItems.quizzes.count >= idx {
            editedItems.quizzes.remove(at: idx)
        }
    }
    
    func initQuizAnswerContent(at idx: Int, answerIdx: Int) {
        if answerIdx < editedItems.quizzes[idx].answers.count {
            editedItems.quizzes[idx].answers[answerIdx].content = ""
        }
    }
    
    func removeQuizAnswer(at idx: Int, answerIdx: Int) {
        if answerIdx < editedItems.quizzes[idx].answers.count {
            editedItems.quizzes[idx].answers.remove(at: answerIdx)
        }
    }
}

struct QuestDetailViewModelItem: Equatable {
    let questId: String
    var missionTitle: String
    var missionType: MissionType
    var quizzes: [Quiz]
    var strengthXP: Int
    var intellectXP: Int
    var funXP: Int
    var charmXP: Int
    var sociabilityXP: Int
    var writer: String
    var score: Int
    var expireDate: String
    var writerImageId: String?
    var writerImage: UIImage?
    var questType: QuestType
    var questTarget: QuestRepeatTarget
    var mainImage: UIImage?
    var mainImageId: String?
    var popularYn: Bool
    
    init(quest: Quest) {
        self.questId = quest.questId
        self.missionTitle = quest.mission.content
        self.missionType = .init(rawValue: quest.mission.type)!
        self.quizzes = quest.mission.quizzes ?? []
        self.strengthXP = quest.rewardList.first(where: { $0.content == "STRENGTH" })?.quantity ?? 0
        self.intellectXP = quest.rewardList.first(where: { $0.content == "INTELLECT" })?.quantity ?? 0
        self.funXP = quest.rewardList.first(where: { $0.content == "FUN" })?.quantity ?? 0
        self.charmXP = quest.rewardList.first(where: { $0.content == "CHARM" })?.quantity ?? 0
        self.sociabilityXP = quest.rewardList.first(where: { $0.content == "SOCIABILITY" })?.quantity ?? 0
        self.writer = quest.writer
        self.score = quest.score
        self.expireDate = quest.expireDate.timeAgoSinceDate()
        self.writerImageId = quest.writerImageId
        self.writerImage = quest.writerImage
        self.questType = QuestType(rawValue: quest.type.lowercased()) ?? .normal
        self.questTarget = QuestRepeatTarget(rawValue: quest.target.lowercased()) ?? .none
        self.mainImage = quest.mainImage
        self.mainImageId = quest.mainImageId
        self.popularYn = quest.popularYn
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

struct QuestRequestMapper {
    static func map(data: QuestDetailViewModelItem) -> PostQuestRequestModel {
        return PostQuestRequestModel(
            writer: data.writer,
            imageId: data.writerImageId,
            missions: [.init(content: data.missionTitle, missionType: data.missionType, quizzes: data.quizzes)],
            rewards: data.toRewardList(),
            score: data.score,
            expireDate: data.expireDate,
            type: data.questType.rawValue.uppercased(),
            target: data.questType == .normal ? "NONE" : data.questTarget.rawValue.uppercased(), // 일반타입이면 "NONE"으로 타겟 설정
            mainImageId: data.mainImageId,
            popularYn: data.popularYn
        )
    }
    
    static func map(data: QuestDetailViewModelItem) -> PutQuestRequestModel {
        return PutQuestRequestModel(
            questId: data.questId,
            writer: data.writer,
            writerImageId: data.writerImageId,
            missions: [.init(content: data.missionTitle, missionType: data.missionType, quizzes: data.quizzes)],
            rewards: data.toRewardList(),
            score: data.score,
            expireDate: data.expireDate,
            target: data.questType == .normal ? "NONE" : data.questTarget.rawValue.uppercased(),
            type: data.questType.rawValue.uppercased(), // 일반타입이면 "NONE"으로 타겟 설정
            mainImageId: data.mainImageId,
            popularYn: data.popularYn
        )
    }
}
