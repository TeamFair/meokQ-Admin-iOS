//
//  ViewAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class ViewAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: - Quest View

        container.register(QuestMainView.self, factory: { (
            resolver: Resolver
        ) -> QuestMainView in
            return .init(vm: resolver.resolve(QuestMainViewModel.self)!)
        }).inObjectScope(.container)

        container.register(QuestDetailView.self, factory: { (
            resolver: Resolver,
            arg1: QuestDetailViewModel.ViewType,
            arg2: Quest
        ) -> QuestDetailView in
            return .init(vm: resolver.resolve(QuestDetailViewModel.self, arguments: arg1, arg2)!)
        }).inObjectScope(.transient)
        
     
        // MARK: - Notice View
        
        container.register(NoticeMainView.self, factory: { (
            resolver: Resolver
        ) -> NoticeMainView in
            return .init(vm: resolver.resolve(NoticeMainViewModel.self)!)
        }).inObjectScope(.container)
        
        container.register(NoticePostView.self, factory: { (
            resolver: Resolver
        ) -> NoticePostView in
            return .init(vm: resolver.resolve(NoticePostViewModel.self)!)
        }).inObjectScope(.container)

        
        container.register(NoticeDetailView.self, factory: { (
            resolver: Resolver,
            arg: Notice
        ) -> NoticeDetailView in
            return .init(vm: resolver.resolve(NoticeDetailViewModel.self, argument: arg)!)
        }).inObjectScope(.container)
    }
}
