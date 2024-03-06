//
//  GetMarketUseCase.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import Combine

protocol GetMarketUseCaseInterface {
    func getMarketList(page: Int) async -> AnyPublisher<[Market], NetworkError>
}

final class GetMarketUseCase: GetMarketUseCaseInterface {
    
    let marketRepository: MarketRepositoryInterface
    
    init(marketRepository: MarketRepositoryInterface) {
        self.marketRepository = marketRepository
    }
    
    func getMarketList(page: Int) async -> AnyPublisher<[Market], NetworkError> {
        return await self.marketRepository.getMarketList(page: page)
    }
}
