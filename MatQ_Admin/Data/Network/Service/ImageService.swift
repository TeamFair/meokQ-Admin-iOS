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
    func postImage(request: PostImageRequest) async -> Result<String, NetworkError>
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
    
    func postImage(request: PostImageRequest) async -> Result<String, NetworkError> {
        // TODO: 호출 전에 압축 & 다운샘플링 하기
        // 이미지 압축 & 다운샘플링
//        var uiImage = request.data
//        var currentCompressionQuality: CGFloat = 0.5
//        if image.size.width > 3000 || image.size.height > 3000 {
//            guard let downSampledImage = image.downSample(scale: 0.8) else {
//                return .failure(NetworkError.invalidImageData)
//            }
//            uiImage = downSampledImage
//        }
//        let imageData = uiImage.jpegData(compressionQuality: currentCompressionQuality) ?? Data()
        
        let imageData = request.data
        let taskRequest = await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "file",
                                     fileName: "image.png",
                                     mimeType: "image/jpeg")
        }, with: ImageTarget.postImage(request))
            .serializingDecodable(PostImageResponseData.self)
            .response
        
        switch  taskRequest.result {
        case .success(let res):
            return .success(res.imageId)
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
