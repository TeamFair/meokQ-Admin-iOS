//
//  GetBannersUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//


import Combine
import UIKit

protocol GetBannersUseCaseInterface {
    func execute() -> AnyPublisher<[Banner], NetworkError>
}

final class GetBannersUseCase: GetBannersUseCaseInterface {
    let bannerRepository: BannerRepositoryInterface
    let imageRepository: ImageRepositoryInterface
    
    init(bannerRepository: BannerRepositoryInterface, imageRepository: ImageRepositoryInterface) {
        self.bannerRepository = bannerRepository
        self.imageRepository = imageRepository
    }
    
    func execute() -> AnyPublisher<[Banner], NetworkError> {
        let request = GetBannersRequest()
        return bannerRepository.getBanners(request: request)
            .flatMap { banners in
                let bannersWithImages = banners.map { banner -> AnyPublisher<Banner, NetworkError> in
                    self.updateBannerImage(banner: banner)
                }
                return Publishers.MergeMany(bannersWithImages)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 이미지 업데이트 처리
    private func updateBannerImage(banner: Banner) -> AnyPublisher<Banner, NetworkError> {
        return updateImage(
            for: banner,
            imageId: banner.imageId,
            keyPath: \.image
        )
    }
    
    private func updateImage(
        for banner: Banner,
        imageId: String?,
        keyPath: WritableKeyPath<Banner, UIImage?>
    ) -> AnyPublisher<Banner, NetworkError> {
        guard let imageId = imageId, !imageId.isEmpty else {
            return Just(banner)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        let imageRequest = GetImageRequest(imageId: imageId)
        return imageRepository.getImage(request: imageRequest)
            .map { image in
                var updatedBanner = banner
                updatedBanner[keyPath: keyPath] = image.resizeImage(newWidth: UIImageSize.medium.value)
                return updatedBanner
            }
            .catch { _ in
                Just(banner)
                    .setFailureType(to: NetworkError.self)
            }
            .eraseToAnyPublisher()
    }
}
