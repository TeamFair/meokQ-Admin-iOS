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
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        // TODO: 이미지 레포 추가
        container.register(PostQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> PostQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(DeleteQuestUseCaseInterface.self, factory: { (
            resolver: Resolver
        ) -> DeleteQuestUseCase in
            return .init(questRepository: resolver.resolve(QuestRepositoryInterface.self)!)
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
