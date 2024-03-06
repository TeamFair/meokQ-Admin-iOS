//
//  MarketAuthRepositoryInterface.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

protocol MarketAuthRepositoryInterface {
    func getMarketAuth(marketId: String) async throws -> [MarketAuth]
    func putMarketAuthReview(recordId: String, comment: String?, reviewResult: ReviewResult) async throws -> Bool
}
