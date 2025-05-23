//
//  BannerRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine
import UIKit

final class BannerRepository: BannerRepositoryInterface {
    let bannerDataSource: BannerDataSourceInterface
    
    init(bannerDataSource: BannerDataSourceInterface) {
        self.bannerDataSource = bannerDataSource
    }
    
    func getBanners(request: GetBannersRequest) -> AnyPublisher<[Banner], NetworkError> {
        bannerDataSource.getBannerList(request: request)
            .map { response in
                response.map { $0.toDomain(image: nil) }
            }
            .eraseToAnyPublisher()
    }
    
    func postBanner(request: PostBannerRequest) -> AnyPublisher<Void, NetworkError> {
        bannerDataSource.postBanner(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func putBanner(request: PutBannerRequest) -> AnyPublisher<Void, NetworkError> {
        bannerDataSource.putBanner(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func deleteBanner(request: DeleteBannerRequest) -> AnyPublisher<Void, NetworkError> {
        bannerDataSource.deleteBanner(request: request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
