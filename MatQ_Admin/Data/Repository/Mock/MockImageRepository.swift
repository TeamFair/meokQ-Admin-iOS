//
//  MockImageRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 10/23/24.
//

import Combine
import UIKit

final class MockImageRepository: ImageRepositoryInterface {
    var result: Result<String, NetworkError>?
    var imageResult: Result<UIImage, NetworkError>?
    var isDeleteImageCalled = false

    func postImage(image: UIImage, type: ImageType) -> AnyPublisher<String, NetworkError> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError> {
        if let result = imageResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        isDeleteImageCalled = true
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func getImageIds(request: GetImageIdsRequest) -> AnyPublisher<[String], NetworkError> {
        return Just(["IIM0000002"])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func getCachedImages() -> AnyPublisher<[(String, UIImage)], Never> {
        return Just([("IIM0000002", .testimage)]).eraseToAnyPublisher()
    }
}
