//
//  ManageDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import UIKit

final class ManageDetailViewModel: ObservableObject {
    
    private let challengeDetail: Challenge
    let item: ManageDetailViewModelItem
    
    // 챌린지 철회&삭제 Alert 관련
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    
    let patchChallengeUseCase: PatchChallengeUseCaseInterface
    let deleteChallengeUseCase: DeleteChallengeUseCaseInterface

    var subscriptions = Set<AnyCancellable>()

    init(challengeDetail: Challenge, patchChallengeUseCase: PatchChallengeUseCaseInterface, deleteChallengeUseCase: DeleteChallengeUseCaseInterface) {
        self.challengeDetail = challengeDetail
        self.item = ManageDetailViewModelItem(challenge: challengeDetail)
        self.patchChallengeUseCase = patchChallengeUseCase
        self.deleteChallengeUseCase = deleteChallengeUseCase
    }
    
    func recoveryChallenge(challengeId: String) {
        patchChallengeUseCase.execute(challengeId: challengeId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "챌린지 신고 철회 실패"
                    if case let NetworkError.error((_, _, errMessage)) = error {
                        self?.alertMessage = errMessage
                    } else {
                        self?.alertMessage = error.message
                    }
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "챌린지 신고 철회 성공"
                self?.alertMessage = "퀘스트가 성공적으로 철회되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    func deleteChallenge(item: ManageDetailViewModelItem) {
        deleteChallengeUseCase.execute(challengeId: item.challengeId, imageId: item.imageId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.alertTitle = "챌린지 삭제 성공"
                    self?.alertMessage = "퀘스트가 성공적으로 삭제되었습니다"
                    self?.activeAlertType = .result
                    self?.showAlert = true
                case .failure(let error):
                    self?.alertTitle = "챌린지 삭제 실패"
                    if case let NetworkError.error((_, _, errMessage)) = error {
                        self?.alertMessage = errMessage
                    } else {
                        self?.alertMessage = error.message
                    }
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
}

extension ManageDetailViewModel {
    enum ActiveAlertType: Identifiable {
        case delete
        case recovery
        case result
        
        var id: Int {
            switch self {
            case .delete:
                return 1
            case .recovery:
                return 2
            case .result:
                return 3
            }
        }
    }
    
}

struct ManageDetailViewModelItem: Equatable {
    let challengeId: String
    let questTitle: String
    let imageId: String?
    let image: UIImage?
    let status: String
    let createdAt: String
    let userNickname: String

    
    init(challengeId: String, questTitle: String, imageId: String?, image: UIImage?, status: String, createdAt: String, userNickname: String) {
        self.challengeId = challengeId
        self.questTitle = questTitle
        self.imageId = imageId
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.userNickname = userNickname
    }
    
    init(challenge: Challenge) {
        self.challengeId = challenge.challengeId
        self.questTitle = challenge.challengeTitle
        self.imageId = challenge.receiptImageId
        self.image = challenge.image
        self.status = challenge.status
        self.createdAt = challenge.createdAt
        self.userNickname = challenge.userNickName
    }
}
