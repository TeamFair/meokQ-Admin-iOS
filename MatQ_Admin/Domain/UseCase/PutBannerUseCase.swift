//
//  PutBannerUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/23/25.
//

import Combine

protocol PutBannerUseCaseInterface {
    func execute(bannerId: Int, title: String, description: String, activeYn: Bool) -> AnyPublisher<Void, NetworkError>
}

final class PutBannerUseCase: PutBannerUseCaseInterface {
    let bannerRepository: BannerRepositoryInterface
    
    init(bannerRepository: BannerRepositoryInterface) {
        self.bannerRepository = bannerRepository
    }
    
    func execute(bannerId: Int, title: String, description: String, activeYn: Bool) -> AnyPublisher<Void, NetworkError> {
        let request = PutBannerRequest(bannerId: bannerId, banner: .init(title: title, description: description, activeYn: activeYn ? "Y" : "N"))
        return bannerRepository.putBanner(request: request)
    }
}
