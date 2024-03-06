//
//  MarketAuthRepository.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Foundation

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
    
    func putMarketAuthReview(recordId: String, comment: String?, reviewResult: ReviewResult) async throws -> Bool {
        let request = PutReviewMarketAuthRequest(recordId: recordId, comment: comment, reviewResult: reviewResult)
        let result = await self.marketAuthService.putMarketReview(request: request)
        
        switch result {
        case .success(let bool):
            return bool
        case .failure:
            throw NetworkError.serverError
        }
    }
}
