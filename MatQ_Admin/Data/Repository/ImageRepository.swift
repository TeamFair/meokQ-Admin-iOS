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
    
    func postImage(image: UIImage) -> AnyPublisher<String, NetworkError> {
        let resizedImage = self.resizeImageIfNeeded(image)
        let compressionQualities: [CGFloat] = [0.4, 0.2, 0.05, 0.002]

        return compressionQualities.publisher
            .flatMap { quality in
                self.uploadCompressedImage(resizedImage, quality: quality)
            }
            .first() // 첫 번째 성공한 업로드 사용
            .eraseToAnyPublisher()
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        imageDataSource.deleteImage(request: request)
    }
    
    /// 이미지 리사이즈 처리
    private func resizeImageIfNeeded(_ image: UIImage) -> UIImage {
        guard image.size.width > 1500 || image.size.height > 1500 else { return image }
        print("RESIZE IMAGE \(image.size.width) \(image.size.height)")
        
        return image.downSample(scale: 0.5) ?? image
    }
    
    /// 이미지 압축 및 업로드
    private func uploadCompressedImage(_ image: UIImage, quality: CGFloat) -> AnyPublisher<String, NetworkError> {
        guard let imageData = image.jpegData(compressionQuality: quality) else {
            return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
        }
        
        let request = PostImageRequest(data: imageData)
        return imageDataSource.postImage(request: request)
            .mapError { _ in NetworkError.serverError }
            .eraseToAnyPublisher()
    }
    
    func getCachedImages() -> AnyPublisher<[(String, UIImage)], Never> {
        imageDataSource.getCachedImages()
    }
}
