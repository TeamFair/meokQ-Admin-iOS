//
//  FetchMarketReviewMaterialsUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/4/24.
//

import Foundation

protocol FetchMarketReviewMaterialsUseCaseInterface {
    func execute(marketId: String) async throws -> (MarketDetail, [MarketAuth])
}

final class FetchMarketReviewMaterialsUseCase: FetchMarketReviewMaterialsUseCaseInterface {
    
    let marketRepository: MarketRepositoryInterface
    let marketAuthRepository: MarketAuthRepositoryInterface
    
    init(marketRepository: MarketRepositoryInterface, marketAuthRepository: MarketAuthRepositoryInterface) {
        self.marketRepository = marketRepository
        self.marketAuthRepository = marketAuthRepository
    }
    
    func execute(marketId: String) async throws -> (MarketDetail, [MarketAuth]){
        let detail = try await getMarketDetail(marketId: marketId)
        let auth = try await getMarketAuth(marketId: marketId)
        return (detail, auth)
    }
    
    private func getMarketDetail(marketId: String) async throws -> MarketDetail {
        return try await self.marketRepository.getMarketDetail(marketId: marketId)
    }
    
    private func getMarketAuth(marketId: String) async throws -> [MarketAuth] {
        return try await self.marketAuthRepository.getMarketAuth(marketId: marketId)
    }
}
