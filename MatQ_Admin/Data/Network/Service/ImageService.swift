//
//  ImageService.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/8/24.
//

import Alamofire
import Combine
import UIKit

protocol ImageServiceInterface {
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError>
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError>
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError>
}

struct ImageService: ImageServiceInterface {
    func getImage(request: GetImageRequest) -> AnyPublisher<UIImage, NetworkError> {
        NetworkUtils.requestImage(ImageTarget.getImage(request))
    }
    
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError> {
        NetworkUtils.upload(ImageTarget.postImage(request).urlRequest!, multipartFormData: { multipartFormData in
            multipartFormData.append(request.data,
                                     withName: "file",
                                     fileName: "image.png",
                                     mimeType: "image/jpeg")
        }, as: PostImageResponse.self)
        .tryMap { response in
            // imageId가 존재하는지 확인
            return response.data.imageId
        }
        .mapError { _ in NetworkError.serverError }
        .eraseToAnyPublisher()
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        NetworkUtils.request(ImageTarget.deleteImage(request), as: DeleteImageResponse.self)
            .map { $0.status }
            .eraseToAnyPublisher()
    }
}
