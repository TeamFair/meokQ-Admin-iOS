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
        container.register(NetworkServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> NetworkService in
            return .init()
        }).inObjectScope(.container)

        
        container.register(QuestServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestService in
            return .init(networkService: resolver.resolve(NetworkServiceInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(ImageServiceInterface.self, factory: { (
            resolver: Resolver
        ) -> ImageService in
            return .init(networkService: resolver.resolve(NetworkServiceInterface.self)!)
        }).inObjectScope(.container)

        
        // MARK: - Repository
        
        container.register(QuestRepositoryInterface.self, factory: { (
            resolver: Resolver
        ) -> QuestRepository in
            return .init(questService: resolver.resolve(QuestServiceInterface.self)!,
                         imageService:  resolver.resolve(ImageServiceInterface.self)!)
        }).inObjectScope(.container)
    }
}
