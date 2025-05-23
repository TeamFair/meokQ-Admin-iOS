//
//  BannerRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import Combine
import UIKit

protocol BannerRepositoryInterface {
    func getBanners(request: GetBannersRequest) -> AnyPublisher<[Banner], NetworkError>
    func postBanner(request: PostBannerRequest) -> AnyPublisher<Void, NetworkError>
    func putBanner(request: PutBannerRequest) -> AnyPublisher<Void, NetworkError>
    func deleteBanner(request: DeleteBannerRequest) -> AnyPublisher<Void, NetworkError>
}
