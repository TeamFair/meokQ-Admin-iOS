//
//  DomainAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class DomainAssembly: Assembly {

    func assemble(container: Container) {
        container.register(GetMarketUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> GetMarketUseCase in
            return .init(marketRepository: resolver.resolve(MarketRepositoryInterface.self)!)
        })
        
        container.register(FetchMarketReviewMaterialsUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> FetchMarketReviewMaterialsUseCase in
            return .init(
                marketRepository: resolver.resolve(MarketRepositoryInterface.self)!,
                marketAuthRepository: resolver.resolve(MarketAuthRepositoryInterface.self)!
            )
        })
    }
}
