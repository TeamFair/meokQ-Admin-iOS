//
//  FetchImageUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 2/28/25.
//

import Combine
import UIKit

protocol FetchImagesUseCaseInterface {
    func execute() -> AnyPublisher<[(imageId: String, image: UIImage)], NetworkError>
}

class FetchImagesUseCase: FetchImagesUseCaseInterface {
    private let imageRepository: ImageRepositoryInterface

    init(imageRepository: ImageRepositoryInterface) {
        self.imageRepository = imageRepository
    }
    
    func execute() -> AnyPublisher<[(imageId: String, image: UIImage)], NetworkError> {
        // BUSINESS_REGISTRATION_CERTIFICATE, ID_CARD, MARKET_LOGO, RECEIPT, QUEST_IMAGE, BANNER_IMAGE, USER_PROFILE_IMAGE
        let type = "QUEST_IMAGE"
        let imageIdsRequest = GetImageIdsRequest(type: type)
        
        return imageRepository.getImageIds(request: imageIdsRequest)
            .flatMap { imageIds in
                // 각 imageId에 대해 비동기 이미지 요청 publisher 생성
                let imagePublishers = imageIds.map { imageId in
                    self.imageRepository.getImage(request: GetImageRequest(imageId: imageId))
                        .map { image in (imageId: imageId, image: image) }
                        .catch { _ in Empty<(imageId: String, image: UIImage), Never>() } // 실패 무시
                }
                
                return Publishers.MergeMany(imagePublishers)
                    .collect() // 결과를 배열로 묶기
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

