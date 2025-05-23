//
//  ImageMainViewModel.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/13/25.
//

import Combine
import UIKit

final class ImageMainViewModel: ObservableObject {
    
    @Published var imageList: [ImageType: [ImageMainViewModelItem]] = [:] // ImageMainViewModelItem.mockData
    
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var activeAlertType: ActiveAlertType?
    @Published var viewType: ViewType
    @Published var selectedImageType: ImageType = .QUEST_IMAGE
    
    // 이미지 삭제, 추가
    private let fetchImagesUseCase: FetchImagesUseCaseInterface
    
    @Published var viewState: ViewState = .loaded
    enum ViewState {
        case empty
        case loading
        case loaded
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    init(fetchImagesUseCase: FetchImagesUseCaseInterface, type: ImageMainViewModel.ViewType) {
        self.fetchImagesUseCase = fetchImagesUseCase
        self.viewType = type
        
        self.loadImages(type: .QUEST_IMAGE)
    }
    
    func loadImages(type: ImageType, isRefresh: Bool = false) {
        // 리프레시가 아니고, 기존 이미지가 이미 있다면 요청 안 함
        if !isRefresh, let existing = imageList[type], !existing.isEmpty {
            return
        }
        
        fetchImagesUseCase.execute(type: type)
            .catch { _ in Just([]) } // 에러 발생 시 빈 배열로 대체
            .sink(receiveValue: { [weak self] images in
                self?.imageList[type, default: []] = images.map({ ImageMainViewModelItem(imageId: $0.imageId, image: $0.image) })
            })
            .store(in: &subscriptions)
    }
    
    func selectImage(imageId: String) {
        NotificationCenter.default.post(
            name: .imageSelected,
            object: nil,
            userInfo: ["imageId": imageId]
        )
    }
    
    func handleChange(type: ImageType) {
        self.selectedImageType = type
        self.loadImages(type: type)
    }
}

extension ImageMainViewModel {
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
    
    enum ViewType {
        case fetchingList
        case selectingItem
    }
}

struct ImageMainViewModelItem: Equatable {
    var imageId: String
    var image: UIImage?
    
    init() {
        self.imageId = ""
        self.image = nil
    }
    
    init(imageId: String, image: UIImage?) {
        self.imageId = imageId
        self.image = image
    }
    
    static let mockData: [ImageMainViewModelItem] = [
        .init(imageId: "11", image: .nullimage),
        .init(imageId: "12",image: .nullimage),
        .init(imageId: "13", image: .testimage),
        .init(imageId: "21", image: .nullimage),
        .init(imageId: "22",image: .nullimage),
        .init(imageId: "23", image: .testimage),
        .init(imageId: "31", image: .nullimage),
        .init(imageId: "32",image: .nullimage),
        .init(imageId: "33", image: .testimage)
    ]
}
