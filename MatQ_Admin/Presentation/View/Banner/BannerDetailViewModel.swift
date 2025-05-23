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
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    
    @Published var showManageImageView: Bool = false

    var isPrimaryButtonDisabled: Bool {
        editedItems.title.isEmpty || editedItems.description.isEmpty || editedItems.imageId.isEmpty || (viewType == .edit && initialItem == editedItems)
    }
    
    private var isObserverRegistered = false

    var subscriptions = Set<AnyCancellable>()
    
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
        
        registerImageSelectedObserver()
    }
    
    private func createBanner(with banner: Banner) {
        postBannerUseCase.execute(title: banner.title, description: banner.description, imageId: banner.imageId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "배너 추가 실패"
                    self?.alertMessage = error.message
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "배너 추가 성공"
                self?.alertMessage = "배너가 성공적으로 추가되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    private func modifyBanner(_ banner: Banner) {
        putBannerUseCase.execute(bannerId: banner.id, title: banner.title, description: banner.description, activeYn: banner.activeYn)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "배너 수정 실패"
                    self?.alertMessage = error.message
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "배너 수정 성공"
                self?.alertMessage = "배너가 성공적으로 수정되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
        
    }
    
    func deleteData(bannerId: Int) {
        deleteBannerUseCase.execute(bannerId: bannerId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "배너 삭제 실패"
                    self?.alertMessage = error.message
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "배너 삭제 성공"
                self?.alertMessage = "퀘스트가 성공적으로 삭제되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    func onPrimaryButtonTap() {
        if viewType == .edit {
             modifyBanner(editedItems)
        } else if viewType == .publish {
            createBanner(with: editedItems)
        }
    }
    
    func onDeleteButtonTap(type: QuestDeleteType) {
        alertTitle = "배너를 삭제하시겠습니까?"
        alertMessage = "배너를 복구할 수 없습니다."
        activeAlertType = .delete
        showAlert = true
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
}
