//
//  ImageDetailViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 2/28/25.
//

import Combine
import UIKit
import _PhotosUI_SwiftUI

// 이미지 삭제, 추가
final class ImageDetailViewModel: ObservableObject {
    // 타입 >> 이미지 정보 조회, 이미지 등록
    let viewType: ViewType
    let imageType: ImageType
    
    // 아이템
    @Published var editedItems: ImageMainViewModelItem
    
    // 이미지 추가&삭제 Alert 관련
    @Published var showAlert: Bool = false
    @Published var alertItem: AlertItem?
    @Published var shouldPop: Bool = false
    private let alertPublisher = PassthroughSubject<AlertItem, Never>()
    
    @Published var showQuestMainView: Bool = false
    @Published var selectedImageType: ImageType
    
    @Published var photosPickerItemForMainImage: PhotosPickerItem?
    
    private let imageRepository: ImageRepositoryInterface
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewType: ViewType,
        imageType: ImageType,
        imageItem: ImageMainViewModelItem,
        imageRepository: ImageRepositoryInterface
    ) {
        self.viewType = viewType
        self.imageType = imageType
        self.selectedImageType = imageType
        self.editedItems = imageItem
        self.imageRepository = imageRepository
        
        bind()
        bindPhotosPicker()
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
    
    private func bindPhotosPicker() {
        $photosPickerItemForMainImage
            .compactMap { $0 }
            .flatMap { item in
                Future<UIImage?, Never> { promise in
                    item.loadTransferable(type: ImageDataTransferable.self) { result in
                        switch result {
                        case .success(let transferable):
                            promise(.success(transferable?.uiImage))
                        case .failure:
                            promise(.success(nil)) // 실패 시 nil로 넘겨 처리
                        }
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                if let image = image {
                    self?.editedItems.image = image
                } else {
                    print("❗️이미지 불러오기 실패")
                }
            }
            .store(in: &cancellables)
    }
    
    func postImage(image: UIImage, type: ImageType) {
        imageRepository.postImage(image: image, type: type)
            .flatMap { [weak self] imageId -> AnyPublisher<(UIImage, String), Never> in
                guard let self = self else { return Just((UIImage(), imageId)).eraseToAnyPublisher() }
                // 이미지 등록 후, 해당 이미지 ID로 이미지를 조회
                return self.getImage(imageId: imageId)
                    .map { ($0, imageId) }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .createFailure(error.message))
                }
            } receiveValue: { [weak self] image, imageId in
                self?.sendAlert(type: .createSuccess({
                    self?.editedItems = ImageMainViewModelItem(imageId: imageId, image: image)
                }))
            }
            .store(in: &cancellables)
    }
    
    func deleteImage(imageId: String) {
        imageRepository.deleteImage(request: DeleteImageRequest(imageId: imageId))
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.sendAlert(type: .deleteFailure(error.message))
                }
            } receiveValue: { [weak self] _ in
                self?.sendAlert(type: .deleteSuccess({
                    self?.dismissView()
                }))
            }
            .store(in: &cancellables)
    }
    
    private func getImage(imageId: String) -> AnyPublisher<UIImage, Never> {
        return imageRepository.getImage(request: GetImageRequest(imageId: imageId))
            .catch { error in
                Just(UIImage()) // 실패한 경우 빈 이미지 반환
            }
            .eraseToAnyPublisher()
    }
    
    func handleChange(type: ImageType) {
        self.selectedImageType = type
    }
    
    func onDeleteButtonTap() {
        self.sendAlert(type: .deleteConfirmation {
            self.deleteImage(imageId: self.editedItems.imageId)
        })
    }
    
    func dismissView() {
        self.shouldPop = true
    }
    
    private func sendAlert(type: ImageAlertType) {
        alertPublisher.send(type.alertItem)
    }
}

extension ImageDetailViewModel {
    enum ViewType: Hashable {
        case publish
        case edit
        
        var title: String {
            switch self {
            case .publish: "이미지 등록"
            case .edit: "이미지 정보"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .publish: "등록"
            case .edit: "삭제"
            }
        }
    }
    
    private enum ImageAlertType {
        case createSuccess(() -> Void)
        case createFailure(String)
        case deleteSuccess(() -> Void)
        case deleteFailure(String)
        case deleteConfirmation(() -> Void)
        
        var alertItem: AlertItem {
            switch self {
            case .createSuccess(let onConfirm):
                return AlertStateFactory.simple(
                    title: "이미지 등록 성공",
                    message: "이미지가 성공적으로 등록되었습니다",
                    onConfirm: onConfirm
                )
            case .createFailure(let message):
                return AlertStateFactory.simple(
                    title: "이미지 등록 실패",
                    message: message
                )
            case .deleteSuccess(let onConfirm):
                return AlertStateFactory.simple(
                    title: "이미지 삭제 성공",
                    message: "이미지가 성공적으로 삭제되었습니다",
                    onConfirm: onConfirm
                )
            case .deleteFailure(let message):
                return AlertStateFactory.simple(
                    title: "이미지 삭제 실패",
                    message: message
                )
            case .deleteConfirmation(let onConfirm):
                return AlertStateFactory.deleteConfirmation(onConfirm: onConfirm)
            }
        }
    }
}
