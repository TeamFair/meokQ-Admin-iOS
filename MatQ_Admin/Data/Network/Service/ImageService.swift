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
        AF.request(ImageTarget.getImage(request))
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let data = response.data, let image = UIImage(data: data) else {
                    throw NetworkError.decodingError
                }
                return image
            }
            .mapError { error in
                return NetworkError.serverError
            }
            .eraseToAnyPublisher()
    }
    
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError> {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(request.data,
                                     withName: "file",
                                     fileName: "image.png",
                                     mimeType: "image/jpeg")
        }, with: ImageTarget.postImage(request).urlRequest!)
        .validate(statusCode: 200..<300)
        .publishDecodable(type: PostImageResponse.self)
        .tryMap { response in
            // imageId가 존재하는지 확인
            guard let imageId = response.value?.data.imageId else {
                throw NetworkError.invalidImageData
            }
            return imageId
        }
        .mapError { error in
            return NetworkError.serverError
        }
        .eraseToAnyPublisher()
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        AF.request(ImageTarget.deleteImage(request))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: DeleteImageResponse.self)
            .value()
            .tryMap { response in
                response.status
            }
            .mapError { _ in
                NetworkError.serverError
            }
            .eraseToAnyPublisher()
    }
}
