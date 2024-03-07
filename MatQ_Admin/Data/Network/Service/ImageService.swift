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
    
    func deleteImage(request: DeleteImageRequest) async -> Result<String, NetworkError> {
        let request = AF.request(ImageTarget.deleteImage(request))
            .serializingDecodable(DeleteImageResponse.self)
        
        switch await request.result {
        case .success(let response):
            return .success(response.status ?? "DeleteImageSuccess")
        case .failure:
            return .failure(NetworkError.serverError)
        }
    }
}
