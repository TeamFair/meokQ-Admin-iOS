//
//  DataAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class DataAssembly: Assembly {
        
    func assemble(container: Container) {
        
        // MARK: - Service
        container.register(NetworkServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> NetworkService in
            return .init()
        }).inObjectScope(.container)

        container.register(ImageCache.self, factory: { (
            resolver: Resolver
        ) -> InMemoryImageCache in
            return .init()
        }).inObjectScope(.container)

        
        // MARK: - DataSource
        container.register(QuestDataSourceInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestDataSource in
            return .init(networkService: resolver.resolve(NetworkServiceInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(ChallengeDataSourceInterface.self, factory: { (
            resolver: Resolver
        ) -> ChallengeDataSource in
            return .init(networkService: resolver.resolve(NetworkServiceInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(ImageDataSourceInterface.self, factory: { (
            resolver: Resolver
        ) -> ImageDataSource in
            return .init(cache: resolver.resolve(ImageCache.self)!, 
                         networkService: resolver.resolve(NetworkServiceInterface.self)!)
        }).inObjectScope(.container)

        
        // MARK: - Repository
        
#if RELEASE
        container.register(QuestRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestRepository in
            return .init(questDataSource: resolver.resolve(QuestDataSourceInterface.self)!)
        }).inObjectScope(.container)
#else
        container.register(QuestRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> MockQuestRepository in
            return .init()
        }).inObjectScope(.container)
#endif
        
         container.register(ChallengeRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> ChallengeRepository in
            return .init(challengeDataSource: resolver.resolve(ChallengeDataSourceInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(ImageRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> ImageRepository in
            return .init(imageDataSource: resolver.resolve(ImageDataSourceInterface.self)!)
        }).inObjectScope(.container)
    }
}
