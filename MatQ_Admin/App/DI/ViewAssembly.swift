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
        
        
        // MARK: - Market View

        container.register(MarketMainView.self, factory: { (
            resolver: Resolver
        ) -> MarketMainView in
            return .init(vm: resolver.resolve(MarketMainViewModel.self)!)
        }).inObjectScope(.container)

        
        container.register(MarketAuthReviewView.self, factory: { (
            resolver: Resolver,
            arg: String
        ) -> MarketAuthReviewView in
            return .init(vm: resolver.resolve(MarketAuthReviewViewModel.self, argument: arg)!)
        }).inObjectScope(.container)

        
        container.register(BusinessRegistrationView.self, factory: { (
            resolver: Resolver,
            arg: License
        ) -> BusinessRegistrationView in
            return .init(license: arg)
        }).inObjectScope(.container)

        container.register(MarketDetailInfoView.self, factory: { (
            resolver: Resolver,
            arg: MarketDetail
        ) -> MarketDetailInfoView in
            return .init(marketDetail: arg)
        }).inObjectScope(.container)
        
        container.register(IdentificationView.self, factory: { (
            resolver: Resolver,
            arg: Operator
        ) -> IdentificationView in
            return .init(operatorData: arg)
        }).inObjectScope(.container)
        
     
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
