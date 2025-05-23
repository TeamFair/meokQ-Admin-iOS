//
//  BannerDataSource.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Alamofire
import Combine
import Foundation

protocol BannerDataSourceInterface {
    func getBannerList(request: GetBannersRequest) -> AnyPublisher<[GetBannersResponseData], NetworkError>
    func postBanner(request: PostBannerRequest) -> AnyPublisher<PostBannerResponse, NetworkError>
    func putBanner(request: PutBannerRequest) -> AnyPublisher<PutBannerResponse, NetworkError>
    func deleteBanner(request: DeleteBannerRequest) -> AnyPublisher<DeleteBannerResponse, NetworkError>
}

struct BannerDataSource: BannerDataSourceInterface {
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func getBannerList(request: GetBannersRequest) -> AnyPublisher<[GetBannersResponseData], NetworkError> {
        networkService.request(BannerTarget.getBanner(request), as: GetBannersResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func postBanner(request: PostBannerRequest) -> AnyPublisher<PostBannerResponse, NetworkError> {
        networkService.request(BannerTarget.postBanner(request), as: PostBannerResponse.self)
    }

    func putBanner(request: PutBannerRequest) -> AnyPublisher<PutBannerResponse, NetworkError> {
        networkService.request(BannerTarget.putBanner(request), as: PutBannerResponse.self)
    }
    
    func deleteBanner(request: DeleteBannerRequest) -> AnyPublisher<DeleteBannerResponse, NetworkError> {
        networkService.request(BannerTarget.deleteBanner(request), as: DeleteBannerResponse.self)
    }
}
