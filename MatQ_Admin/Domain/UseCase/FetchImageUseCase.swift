//
//  FetchImageUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 2/28/25.
//

import Combine
import UIKit

protocol FetchImagesUseCaseInterface {
    func execute() -> AnyPublisher<[(imageId: String, image: UIImage)], Never>
}

class FetchImagesUseCase: FetchImagesUseCaseInterface {
    private let imageRepository: ImageRepositoryInterface

    init(imageRepository: ImageRepositoryInterface) {
        self.imageRepository = imageRepository
    }
    
    func execute() -> AnyPublisher<[(imageId: String, image: UIImage)], Never> {
        return imageRepository.getCachedImages()
            .map { images in
                images.map { (imageId: $0.0, image: $0.1) }
            }
            .eraseToAnyPublisher()
    }
}
