//
//  DeleteBannerUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/20/24.
//

import Combine

protocol DeleteBannerUseCaseInterface {
    func execute(bannerId: Int) -> AnyPublisher<Void, NetworkError>
}

final class DeleteBannerUseCase: DeleteBannerUseCaseInterface {
    let bannerRepository: BannerRepositoryInterface
    
    init(bannerRepository: BannerRepositoryInterface) {
        self.bannerRepository = bannerRepository
    }
    
    func execute(bannerId: Int) -> AnyPublisher<Void, NetworkError> {
        let request = DeleteBannerRequest(bannerId: bannerId)
        return bannerRepository.deleteBanner(request: request)
    }
}
