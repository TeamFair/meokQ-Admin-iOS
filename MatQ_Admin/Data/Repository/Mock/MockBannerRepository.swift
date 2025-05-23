//
//  MockBannerRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine

final class MockBannerRepository: BannerRepositoryInterface {
    var result: Result<Void, NetworkError>?
    var bannerResult: Result<[Banner], NetworkError>? = .success(Banner.mockDataList)
    
    func getBanners(request: GetBannersRequest) -> AnyPublisher<[Banner], NetworkError> {
        publisher(for: bannerResult)
    }
    
    func postBanner(request: PostBannerRequest) -> AnyPublisher<Void, NetworkError> {
        publisher(for: result)
    }
    
    func putBanner(request: PutBannerRequest) -> AnyPublisher<Void, NetworkError> {
        publisher(for: result)
    }
    
    func deleteBanner(request: DeleteBannerRequest) -> AnyPublisher<Void, NetworkError> {
        publisher(for: result)
    }
}

private func publisher<T>(for result: Result<T, NetworkError>?) -> AnyPublisher<T, NetworkError> {
    if let result = result {
        return result.publisher.eraseToAnyPublisher()
    }
    return Fail(error: .unknownError).eraseToAnyPublisher()
}
