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
        
        container.register(QuestServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestService in
            return .init()
        }).inObjectScope(.container)
        
        container.register(MarketServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketService in
            return .init()
        }).inObjectScope(.container)

        
        container.register(MarketAuthServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketAuthService in
            return .init()
        }).inObjectScope(.container)

        
        container.register(ImageServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> ImageService in
            return .init()
        }).inObjectScope(.container)

        
        container.register(NoticeServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> NoticeService in
            return .init()
        }).inObjectScope(.container)

        
        
        // MARK: - Repository
        
        container.register(QuestRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestRepository in
            return .init(questService: resolver.resolve(QuestServiceInterface.self)!,
                         imageService:  resolver.resolve(ImageServiceInterface.self)!)
        }).inObjectScope(.container)

          container.register(MarketRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketRepository in
            return .init(marketService: resolver.resolve(MarketServiceInterface.self)!,
                         imageService: resolver.resolve(ImageServiceInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(MarketAuthRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> MarketAuthRepository in
            return .init(marketAuthService: resolver.resolve(MarketAuthServiceInterface.self)!,
                         imageService: resolver.resolve(ImageServiceInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(NoticeRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> NoticeRepository in
            return .init(noticeService: resolver.resolve(NoticeServiceInterface.self)!)
        }).inObjectScope(.container)

    }
}
