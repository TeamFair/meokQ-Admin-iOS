//
//  MarketAuthRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Combine

protocol MarketAuthRepositoryInterface {
    func getMarketAuth(marketId: String) async throws -> [MarketAuth]
    func putMarketAuthReview(recordId: String, comment: String?, reviewResult: ReviewResult) async -> AnyPublisher<Bool, NetworkError>
}
