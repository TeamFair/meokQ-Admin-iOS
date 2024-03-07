//
//  MarketAuthRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Combine

final class MarketAuthRepository: MarketAuthRepositoryInterface {
    
    let marketAuthService: MarketAuthServiceInterface
    
    init(marketAuthService: MarketAuthServiceInterface) {
        self.marketAuthService = marketAuthService
    }
    
    func getMarketAuth(marketId: String) async throws -> [MarketAuth] {
        let request = GetMarketAuthRequest(marketId: marketId)
        let result = await self.marketAuthService.getMarketAuth(request: request)
        
        switch result {
        case .success(let markets):
            return markets
        case .failure:
            throw NetworkError.serverError
        }
    }
    
    func putMarketAuthReview(recordId: String, comment: String?, reviewResult: ReviewResult) async -> AnyPublisher<Bool, NetworkError> {
        let request = PutReviewMarketAuthRequest(recordId: recordId, comment: comment, reviewResult: reviewResult.statusText)
        let result = await self.marketAuthService.putMarketReview(request: request)
        
        return Future<Bool, NetworkError> { promise in
            switch result {
            case .success(let bool):
                promise(.success(bool))
            case .failure:
                promise(.failure(NetworkError.serverError))
            }
        }.eraseToAnyPublisher()
    }
}
