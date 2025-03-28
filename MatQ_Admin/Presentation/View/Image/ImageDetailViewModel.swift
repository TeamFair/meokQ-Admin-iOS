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
    
    // 아이템
    let item: ImageMainViewModelItem
    @Published var editedItems: ImageMainViewModelItem
    
    // 이미지 추가&삭제 Alert 관련
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    
    @Published var photosPickerItemForMainImage: PhotosPickerItem? {
        didSet {
            Task {
                if let imageDataTransferable = try? await photosPickerItemForMainImage?.loadTransferable(type: ImageDataTransferable.self) {
                    self.editedItems.image = imageDataTransferable.uiImage
                }
            }
        }
    }
    
    let imageRepository: ImageRepositoryInterface
    var subscriptions = Set<AnyCancellable>()
    
    init(
        viewType: ViewType,
        imageItem: ImageMainViewModelItem,
        imageRepository: ImageRepositoryInterface
    ) {
        self.viewType = viewType
        self.item = imageItem
        self.editedItems = imageItem
        self.imageRepository = imageRepository
    }
    
    func postImage(image: UIImage) {
        imageRepository.postImage(image: image)
            .flatMap { [weak self] imageId -> AnyPublisher<(UIImage, String), Never> in
                guard let self = self else { return Just((UIImage(), imageId)).eraseToAnyPublisher() }
                // 이미지 등록 후, 해당 이미지 ID로 이미지를 조회
                return self.getImage(imageId: imageId)
                    .map { image in
                        return (image, imageId) // 이미지를 가져온 후, 이미지와 아이디를 함께 반환
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "이미지 등록 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] image, imageId in
                self?.alertTitle = "이미지 등록 성공"
                self?.alertMessage = "이미지가 성공적으로 등록되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
                self?.editedItems = ImageMainViewModelItem(imageId: imageId, image: image)
            }
            .store(in: &subscriptions)
    }
    
    func deleteImage(imageId: String) {
        imageRepository.deleteImage(request: DeleteImageRequest(imageId: imageId))
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.alertTitle = "이미지 삭제 실패"
                    self?.alertMessage = error.localizedDescription
                    self?.activeAlertType = .result
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] _ in
                self?.alertTitle = "이미지 삭제 성공"
                self?.alertMessage = "이미지가 성공적으로 삭제되었습니다"
                self?.activeAlertType = .result
                self?.showAlert = true
            }
            .store(in: &subscriptions)
    }
    
    private func getImage(imageId: String) -> AnyPublisher<UIImage, Never> {
        return imageRepository.getImage(request: GetImageRequest(imageId: imageId))
            .catch { error in
                Just(UIImage()) // 실패한 경우 빈 이미지 반환
            }
            .eraseToAnyPublisher()
    }
}

extension ImageDetailViewModel {
    enum ViewType {
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
    
    enum ActiveAlertType: Identifiable {
        case delete
        case result
        
        var id: Int {
            switch self {
            case .delete: 1
            case .result: 2
            }
        }
    }
}
