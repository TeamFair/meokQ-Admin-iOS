//
//  ImageService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/8/24.
//

import Alamofire
import Combine
import UIKit

protocol ImageDataSourceInterface {
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError>
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError>
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError>
}

final class ImageDataSource: ImageDataSourceInterface {
    private let networkService: NetworkServiceInterface
    private var cache: ImageCache
    
    init(cache: ImageCache, networkService: NetworkServiceInterface) {
        self.cache = cache
        self.networkService = networkService
    }

    private var imageRequestInProgress: [String: AnyPublisher<UIImage, NetworkError>] = [:]

    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError> {
        // 캐시에서 먼저 확인
        if let cachedImage = self.cache.getImage(forKey: request.imageId) {
            return Just(cachedImage)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        // 중복된 이미지 요청이 있을 경우, 이미 진행 중인 요청을 반환
        if let ongoingRequest = imageRequestInProgress[request.imageId] {
            return ongoingRequest
        }
        
        
        let publisher = networkService.requestImage(ImageTarget.getImage(request))
            .map { image in
                // 네트워크에서 이미지 가져오면 캐시에 저장
                self.cache.saveImage(image, forKey: request.imageId)
                return image
            }
            .handleEvents(
                receiveCompletion: { _ in
                    // 요청이 완료되면 진행 중인 요청을 삭제
                    DispatchQueue.main.async {
                        self.imageRequestInProgress.removeValue(forKey: request.imageId)
                    }
                },
                receiveCancel: {
                    // 요청 취소시 진행 중인 요청을 삭제
                    DispatchQueue.main.async {
                        self.imageRequestInProgress.removeValue(forKey: request.imageId)
                    }
                }
            )
            .share()
            .eraseToAnyPublisher()
        
        // 진행 중인 요청을 저장하여 중복 요청을 방지
        imageRequestInProgress[request.imageId] = publisher
        
        return publisher
    }
    
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError> {
        networkService.upload(ImageTarget.postImage(request).urlRequest!, multipartFormData: { multipartFormData in
            multipartFormData.append(request.data,
                                     withName: "file",
                                     fileName: "image.png",
                                     mimeType: "image/jpeg")
        }, as: PostImageResponse.self)
        .tryMap { response in
            // imageId가 존재하는지 확인
            print("이미지 업로드", response.data.imageId)
            return response.data.imageId
        }
        .mapError { _ in NetworkError.serverError }
        .eraseToAnyPublisher()
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        networkService.request(ImageTarget.deleteImage(request), as: DeleteImageResponse.self)
            .map { response in
                // 삭제 후 캐시에서 해당 이미지도 제거
                self.cache.deleteImage(forKey: request.imageId)
                return response.status
            }            .eraseToAnyPublisher()
    }
}
