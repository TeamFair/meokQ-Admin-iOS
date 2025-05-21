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
        let compressionQualities: [CGFloat] = [0.8, 0.6, 0.4, 0.3, 0.2, 0.1, 0.05, 0.02, 0.002]

        /// 재귀적으로 시도하며 성공 시 종료
        func attemptUpload(qualities: [CGFloat]) -> AnyPublisher<String, NetworkError> {
            guard let quality = qualities.first else {
                return Fail(error: NetworkError.invalidImageData).eraseToAnyPublisher()
            }

            return self.uploadCompressedImage(resizedImage, quality: quality)
                .catch { _ in
                    attemptUpload(qualities: Array(qualities.dropFirst()))
                }
                .eraseToAnyPublisher()
        }

        return attemptUpload(qualities: compressionQualities)
    }
    
    func deleteImage(request: DeleteImageRequest) -> AnyPublisher<String, NetworkError> {
        imageDataSource.deleteImage(request: request)
    }
    
    /// 이미지 리사이즈 처리
    private func resizeImageIfNeeded(_ image: UIImage) -> UIImage {
        let maxSize: CGFloat = 900
        let highThreshold: CGFloat = 3000
        
        let width = image.size.width
        let height = image.size.height
        
        guard width > maxSize || height > maxSize else { return image } // 리사이징 필요 없음
        
        let scale: CGFloat = (width > highThreshold || height > highThreshold) ? 0.32 : 0.5
        print("RESIZE IMAGE  scale: \(scale)  width: \(width)  height: \(height)")
        
        return image.downSample(scale: scale) ?? image
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

    func getImageIds(request: GetImageIdsRequest) -> AnyPublisher<[String], NetworkError> {
        imageDataSource.getImageIds(request: request)
            .eraseToAnyPublisher()
    }
}
