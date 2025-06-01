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
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertItem?
    @Published var shouldPop: Bool = false
    private let alertPublisher = PassthroughSubject<AlertItem, Never>()
    
    let patchChallengeUseCase: PatchChallengeUseCaseInterface
    let deleteChallengeUseCase: DeleteChallengeUseCaseInterface
    
    var cancellables = Set<AnyCancellable>()
    
    init(challengeDetail: Challenge, patchChallengeUseCase: PatchChallengeUseCaseInterface, deleteChallengeUseCase: DeleteChallengeUseCaseInterface) {
        self.challengeDetail = challengeDetail
        self.item = ManageDetailViewModelItem(challenge: challengeDetail)
        self.patchChallengeUseCase = patchChallengeUseCase
        self.deleteChallengeUseCase = deleteChallengeUseCase
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
    
    func recoveryChallenge(challengeId: String) {
        patchChallengeUseCase.execute(challengeId: challengeId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .recoveryFailure(error.message))
                }
            } receiveValue: { [weak self] _ in
                self?.sendAlert(type: .recoverySuccess)
            }
            .store(in: &cancellables)
    }
    
    func deleteChallenge(item: ManageDetailViewModelItem) {
        deleteChallengeUseCase.execute(challengeId: item.challengeId, imageId: item.imageId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .deleteFailure(error.message))
                }
            }, receiveValue: { [weak self] _ in
                self?.sendAlert(type: .deleteSuccess {
                    self?.dismissView()
                })
            })
            .store(in: &cancellables)
    }
    
    func onRecoveryButtonTap() {
        self.sendAlert(type: .recoveryConfirmation {
            self.recoveryChallenge(challengeId: self.item.challengeId)
        })
    }
    
    func onDeleteButtonTap() {
        self.sendAlert(type: .deleteConfirmation {
            self.deleteChallenge(item: self.item)
        })
    }
    
    private func sendAlert(type: ManageChallengeAlertType) {
        alertPublisher.send(type.alertItem)
    }
    
    func dismissView() {
        self.shouldPop = true
    }
    
    private enum ManageChallengeAlertType {
        case recoveryConfirmation(() -> Void)
        case recoverySuccess
        case recoveryFailure(String)
        case deleteConfirmation(() -> Void)
        case deleteSuccess(() -> Void)
        case deleteFailure(String)
        
        var alertItem: AlertItem {
            switch self {
            case .recoveryConfirmation(let onConfirm):
                AlertStateFactory.destructiveConfirmation(
                    title: "도전 내역 신고 상태를 철회하시겠습니까?",
                    message: "도전 내역은 완료 상태로 복구됩니다",
                    onConfirm: onConfirm
                )
            case .recoverySuccess:
                AlertStateFactory.simple(
                    title: "신고된 도전 내역 철회 성공",
                    message: "도전 내역이 성공적으로 철회되었습니다"
                )
            case .recoveryFailure(let message):
                AlertStateFactory.simple(
                    title: "신고된 도전 내역 철회 실패",
                    message: message
                )
            case .deleteConfirmation(let onConfirm):
                AlertStateFactory.deleteConfirmation(onConfirm: onConfirm)
            case .deleteSuccess(let onConfirm):
                AlertStateFactory.simple(
                    title: "신고된 도전 내역 삭제 성공",
                    message: "도전 내역이 성공적으로 삭제되었습니다",
                    onConfirm: onConfirm
                )
            case .deleteFailure(let message):
                AlertStateFactory.simple(
                    title: "신고된 도전 내역 삭제 실패",
                    message: message
                )
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
