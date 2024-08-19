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
    }
}
