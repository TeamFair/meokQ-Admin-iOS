//
//  PutMarketReviewUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/7/24.
//

import Combine

protocol PutMarketReviewUseCaseInterface {
    func putMarketReview(recordId: String, comment: String?, reviewResult: ReviewResult) async -> AnyPublisher<Bool, NetworkError>
}

final class PutMarketReviewUseCase: PutMarketReviewUseCaseInterface {
    
    let marketAuthRepository: MarketAuthRepositoryInterface
    
    init(marketAuthRepository: MarketAuthRepositoryInterface) {
        self.marketAuthRepository = marketAuthRepository
    }
    
    func putMarketReview(recordId: String, comment: String?, reviewResult: ReviewResult) async -> AnyPublisher<Bool, NetworkError> {
        return await self.marketAuthRepository.putMarketAuthReview(recordId: recordId, comment: comment, reviewResult: reviewResult)
    }
}
