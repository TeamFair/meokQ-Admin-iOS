//
//  DataAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class DataAssembly: Assembly {
        
    func assemble(container: Container) {
        
        // MARK: - SERVICE
        
        container.register(MarketServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketService in
            return .init()
        })
        
        container.register(MarketAuthServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketAuthService in
            return .init()
        })
        
        
        // MARK: - Repository
        
        container.register(MarketRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketRepository in
            return .init(marketService: resolver.resolve(MarketServiceInterface.self)!)
        })
        
        container.register(MarketAuthRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketAuthRepository in
            return .init(marketAuthService: resolver.resolve(MarketAuthServiceInterface.self)!)
        })
    }
}
