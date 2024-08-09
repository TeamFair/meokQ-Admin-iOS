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
    func getImage(request: GetImageRequest) async -> Result<UIImage, NetworkError>
    func postImage(request: PostImageRequest) -> AnyPublisher<String, NetworkError>
    func deleteImage(request: DeleteImageRequest) async -> Result<String, NetworkError>
}

struct ImageService: ImageServiceInterface {
    func getImage(request: GetImageRequest) async -> Result<UIImage, NetworkError> {
        let taskRequest = AF.request(ImageTarget.getImage(request))
            .serializingData()
        
        switch await taskRequest.result {
        case .success(let imageData):
            guard let image = UIImage(data: imageData) else {
                return .failure(NetworkError.decodingError)
            }
            return .success(image)
        case .failure:
            return .failure(NetworkError.serverError)
        }
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
    
    func deleteImage(request: DeleteImageRequest) async -> Result<String, NetworkError> {
        let request = AF.request(ImageTarget.deleteImage(request))
            .serializingDecodable(DeleteImageResponse.self)
        
        switch await request.result {
        case .success(let response):
            return .success(response.status)
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
}
