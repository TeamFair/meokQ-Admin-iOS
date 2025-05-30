//
//  DomainAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class DomainAssembly: Assembly {

    func assemble(container: Container) {
        container.register(GetQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> GetQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!, imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(PostQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PostQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!, imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(PutQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PutQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(DeleteQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> DeleteQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(GetChallengeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> GetChallengeUseCase in
            return .init(challengeRepository: resolver.resolve(ChallengeRepositoryInterface.self)!, imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(PatchChallengeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PatchChallengeUseCase in
            return .init(challengeRepository: resolver.resolve(ChallengeRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(DeleteChallengeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> DeleteChallengeUseCase in
            return .init(challengeRepository: resolver.resolve(ChallengeRepositoryInterface.self)!, 
                         imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(GetBannersUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> GetBannersUseCase in
            return .init(bannerRepository: resolver.resolve(BannerRepositoryInterface.self)!,
                         imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(PostBannerUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PostBannerUseCase in
            return .init(bannerRepository: resolver.resolve(BannerRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(PutBannerUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PutBannerUseCase in
            return .init(bannerRepository: resolver.resolve(BannerRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(DeleteBannerUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> DeleteBannerUseCase in
            return .init(bannerRepository: resolver.resolve(BannerRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(FetchImagesUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> FetchImagesUseCase in
            return .init(imageRepository: resolver.resolve(ImageRepositoryInterface.self)!)
        }).inObjectScope(.container)
    }
}
