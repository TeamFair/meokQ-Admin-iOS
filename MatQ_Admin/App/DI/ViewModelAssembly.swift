//
//  ViewModelAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MarketMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> MarketMainViewModel in
            return .init(marketUseCase: resolver.resolve(GetMarketUseCaseInterface.self)!)
        })
        
        container.register(MarketAuthReviewViewModel.self, factory: { (
            resolver: Resolver,
            arg: String
        ) -> MarketAuthReviewViewModel in
            return .init(
                marketAuthUseCase: resolver.resolve(FetchMarketReviewMaterialsUseCaseInterface.self)!, 
                putMarketAuthUseCase: resolver.resolve(PutMarketReviewUseCaseInterface.self)!,
                marketId: arg
            )
        })
        
    }
}
