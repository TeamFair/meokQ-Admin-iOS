//
//  ImageRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import Combine
import UIKit

final class ImageRepository: ImageRepositoryInterface {
    let imageDataSource: ImageDataSourceInterface
    
    init(imageDataSource: ImageDataSourceInterface) {
        self.imageDataSource = imageDataSource
    }
    
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError> {
        imageDataSource.getImage(request: request)
    }
    
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError> {
        imageDataSource.postImage(request: request)
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        imageDataSource.deleteImage(request: request)
    }
}
