//
//  BannerDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine
import UIKit

final class BannerDetailViewModel: ObservableObject {
    let viewType: ViewType
    
    let initialItem: Banner
    @Published var editedItems: Banner
    
    // 퀘스트 추가&삭제 Alert 관련
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertItem?
    @Published var shouldPop: Bool = false
    private let alertPublisher = PassthroughSubject<AlertItem, Never>()
    
    @Published var showManageImageView: Bool = false
    
    var isPrimaryButtonDisabled: Bool {
        editedItems.title.isEmpty || editedItems.description.isEmpty || editedItems.imageId.isEmpty || (viewType == .edit && initialItem == editedItems)
    }
    
    private var isObserverRegistered = false
    
    var cancellables = Set<AnyCancellable>()
    
    private let postBannerUseCase: PostBannerUseCaseInterface
    private let putBannerUseCase: PutBannerUseCaseInterface
    private let deleteBannerUseCase: DeleteBannerUseCaseInterface
    private let imageCache: ImageCache
    
    init(
        viewType: ViewType,
        banner: Banner,
        postBannerUseCase: PostBannerUseCaseInterface,
        putBannerUseCase: PutBannerUseCaseInterface,
        deleteBannerUseCase: DeleteBannerUseCaseInterface,
        imageCache: ImageCache
    ) {
        self.viewType = viewType
        self.initialItem = banner
        self.editedItems = banner
        self.postBannerUseCase = postBannerUseCase
        self.putBannerUseCase = putBannerUseCase
        self.deleteBannerUseCase = deleteBannerUseCase
        self.imageCache = imageCache
        bind()
        registerImageSelectedObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    private func createBanner(with banner: Banner) {
        postBannerUseCase.execute(title: banner.title, description: banner.description, imageId: banner.imageId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .createFailure(error.message))
                }
            } receiveValue: { [weak self] _ in
                self?.sendAlert(type: .createSuccess {
                    self?.dismissView()
                })
            }
            .store(in: &cancellables)
    }
    
    private func modifyBanner(_ banner: Banner) {
        putBannerUseCase.execute(bannerId: banner.id, title: banner.title, description: banner.description, activeYn: banner.activeYn)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .updateFailure(error.message))
                }
            } receiveValue: { [weak self] _ in
                self?.sendAlert(type: .updateSuccess)
            }
            .store(in: &cancellables)
    }
    
    func deleteData(bannerId: Int) {
        deleteBannerUseCase.execute(bannerId: bannerId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .deleteFailure(error.message))
                }
            } receiveValue: { [weak self] _ in
                self?.sendAlert(type: .deleteSuccess {
                    self?.dismissView()
                })
            }
            .store(in: &cancellables)
    }
    
    func onPrimaryButtonTap() {
        if viewType == .edit {
            modifyBanner(editedItems)
        } else if viewType == .publish {
            createBanner(with: editedItems)
        }
    }
    
    func onDeleteButtonTap() {
        self.sendAlert(type: .deleteConfirmation {
            self.deleteData(bannerId: self.editedItems.id)
        })
    }
    
    private func registerImageSelectedObserver() {
        guard !isObserverRegistered else { return }
        isObserverRegistered = true
        
        NotificationCenter.default.addObserver(forName: .imageSelected, object: nil, queue: .main) { [weak self] notification in
            self?.handleImageSelected(notification)
        }
    }
    
    private func handleImageSelected(_ notification: Notification) {
        guard let imageId = notification.userInfo?["imageId"] as? String else { return }
        
        self.editedItems.imageId = imageId
        self.editedItems.image = imageCache.getImage(forKey: imageId)
    }
    
    func dismissView() {
        self.shouldPop = true
    }
    
    private func sendAlert(type: BannerAlertType) {
        alertPublisher.send(type.alertItem)
    }
}

extension BannerDetailViewModel {
    enum ViewType {
        case publish
        case edit
        
        var title: String {
            switch self {
            case .publish:
                "배너 생성"
            case .edit:
                "배너 수정"
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
    
    private enum BannerAlertType {
        case createSuccess(() -> Void)
        case createFailure(String)
        case updateSuccess
        case updateFailure(String)
        case deleteSuccess(() -> Void)
        case deleteFailure(String)
        case deleteConfirmation(() -> Void)
        
        var alertItem: AlertItem {
            switch self {
            case .createSuccess(let onConfirm):
                return AlertStateFactory.simple(
                    title: "배너 추가 성공",
                    message: "배너가 성공적으로 추가되었습니다",
                    onConfirm: onConfirm
                )
            case .createFailure(let message):
                return AlertStateFactory.simple(
                    title: "배너 추가 실패",
                    message: message
                )
            case .updateSuccess:
                return AlertStateFactory.simple(
                    title: "배너 수정 성공",
                    message: "배너가 성공적으로 수정되었습니다"
                )
            case .updateFailure(let message):
                return AlertStateFactory.simple(
                    title: "배너 수정 실패",
                    message: message
                )
            case .deleteSuccess(let onConfirm):
                return AlertStateFactory.simple(
                    title: "배너 삭제 성공",
                    message: "배너가 성공적으로 삭제되었습니다",
                    onConfirm: onConfirm
                )
            case .deleteFailure(let message):
                return AlertStateFactory.simple(
                    title: "배너 삭제 실패",
                    message: message
                )
            case .deleteConfirmation(let onConfirm):
                return AlertStateFactory.deleteConfirmation(onConfirm: onConfirm)
            }
        }
    }
}
