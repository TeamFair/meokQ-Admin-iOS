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
        }).inObjectScope(.container)

        
        container.register(FetchMarketReviewMaterialsUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> FetchMarketReviewMaterialsUseCase in
            return .init(
                marketRepository: resolver.resolve(MarketRepositoryInterface.self)!,
                marketAuthRepository: resolver.resolve(MarketAuthRepositoryInterface.self)!
            )
        }).inObjectScope(.container)

        
        container.register(PutMarketReviewUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PutMarketReviewUseCase in
            return .init(marketAuthRepository: resolver.resolve(MarketAuthRepositoryInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(GetNoticeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> GetNoticeUseCase in
            return .init(noticeRepository: resolver.resolve(NoticeRepositoryInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(PostNoticeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PostNoticeUseCase in
            return .init(noticeRepository: resolver.resolve(NoticeRepositoryInterface.self)!)
        }).inObjectScope(.container)

        
        container.register(DeleteNoticeUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> DeleteNoticeUseCase in
            return .init(noticeRepository: resolver.resolve(NoticeRepositoryInterface.self)!)
        }).inObjectScope(.container)
    }
}
