//
//  DeleteImageUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/16/24.
//

import Foundation
import Combine

protocol DeleteImageUseCaseInterface {
    func execute(imageId: String) -> AnyPublisher<String, NetworkError>
}

final class DeleteImageUseCase: DeleteImageUseCaseInterface {
    
    let imageRepository: ImageRepositoryInterface
    
    init(imageRepository: ImageRepositoryInterface) {
        self.imageRepository = imageRepository
    }
    
    func execute(imageId: String) -> AnyPublisher<String, NetworkError> {
        self.imageRepository.deleteImage(request: DeleteImageRequest(imageId: imageId))
    }
}
