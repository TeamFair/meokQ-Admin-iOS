//
//  PostBannerUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine

protocol PostBannerUseCaseInterface {
    func execute(title: String, description: String, imageId: String) -> AnyPublisher<Void, NetworkError>
}

final class PostBannerUseCase: PostBannerUseCaseInterface {
    let bannerRepository: BannerRepositoryInterface
    
    init(bannerRepository: BannerRepositoryInterface) {
        self.bannerRepository = bannerRepository
    }
    
    func execute(title: String, description: String, imageId: String) -> AnyPublisher<Void, NetworkError> {
        let request = PostBannerRequest(title: title, description: description, imageId: imageId)
        return bannerRepository.postBanner(request: request)
    }
}
