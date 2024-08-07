//
//  ViewModelAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(QuestMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> QuestMainViewModel in
            return .init(questUseCase: resolver.resolve(GetQuestUseCaseInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(QuestDetailViewModel.self, factory: { (
            resolver: Resolver,
            arg1: QuestDetailViewModel.ViewType,
            arg2: Quest
        ) -> QuestDetailViewModel in
            return .init(viewType: arg1, 
                         questDetail: arg2,
                         postQuestUseCase: resolver.resolve(PostQuestUseCaseInterface.self)!,
                         deleteQuestUseCase: resolver.resolve(DeleteQuestUseCaseInterface.self)!)
        }).inObjectScope(.transient)

        container.register(NoticeMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> NoticeMainViewModel in
            return .init(
                noticeUseCase: resolver.resolve(GetNoticeUseCaseInterface.self)!
            )
        }).inObjectScope(.container)
        
        container.register(NoticePostViewModel.self, factory: { (
            resolver: Resolver
        ) -> NoticePostViewModel in
            return .init(
                noticeUseCase: resolver.resolve(PostNoticeUseCaseInterface.self)!
            )
        }).inObjectScope(.container)

        container.register(NoticeDetailViewModel.self, factory: { (
            resolver: Resolver,
            arg: Notice
        ) -> NoticeDetailViewModel in
            return .init(
                noticeUseCase: resolver.resolve(DeleteNoticeUseCaseInterface.self)!,
                notice: arg
            )
        }).inObjectScope(.container)
    }
}
