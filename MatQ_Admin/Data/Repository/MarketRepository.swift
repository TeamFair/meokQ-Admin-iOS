//
//  MarketRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Combine
import UIKit

final class MarketRepository: MarketRepositoryInterface {
    
    let marketService: MarketServiceInterface
    let imageService: ImageServiceInterface
    
    init(marketService: MarketServiceInterface, imageService: ImageServiceInterface) {
        self.marketService = marketService
        self.imageService = imageService
    }
    
    func getMarketList(page: Int) async -> AnyPublisher<[Market], NetworkError> {
        let request = GetMarketListRequest(page: page)
        let marketListResponse = await self.marketService.fetchMarketList(request: request)

        return Future<[Market], NetworkError> { promise in
            switch marketListResponse {
            case .success(let res):
                promise(.success(res))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
  
    func getMarketDetail(marketId: String) async throws -> MarketDetail {
        let result = await self.marketService.fetchMarketDetail(request: GetMarketDetailRequest(marketId: marketId))
        switch result {
        case .success(let movies):
            return movies
        case .failure:
            throw NetworkError.serverError
        }
    }
}
