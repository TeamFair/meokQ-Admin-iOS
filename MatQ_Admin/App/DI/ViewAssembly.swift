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
        
        
        // MARK: - Manage View
        
        container.register(ManageMainView.self, factory: { (
            resolver: Resolver
        ) -> ManageMainView in
            return .init(vm: resolver.resolve(ManageMainViewModel.self)!)
        }).inObjectScope(.container)
        
        container.register(ManageDetailView.self, factory: { (
            resolver: Resolver,
            arg1: Challenge
        ) -> ManageDetailView in
            return .init(vm: resolver.resolve(ManageDetailViewModel.self, argument: arg1)!)
        }).inObjectScope(.transient)
        
        
        // MARK: - Banner View
        
        container.register(BannerMainView.self, factory: { (
            resolver: Resolver
        ) -> BannerMainView in
            return .init(vm: resolver.resolve(BannerMainViewModel.self)!)
        }).inObjectScope(.container)
        
        
        container.register(BannerDetailView.self, factory: { (
            resolver: Resolver,
            arg1: BannerDetailViewModel.ViewType,
            arg2: Banner
        ) -> BannerDetailView in
            return .init(vm: resolver.resolve(BannerDetailViewModel.self, arguments: arg1, arg2)!)
        }).inObjectScope(.transient)
        
        
        // MARK: - Image View
        
        container.register(ImageMainView.self, factory: { (
            resolver: Resolver,
            arg1: ImageMainViewModel.ViewType
        ) -> ImageMainView in
            return .init(vm: resolver.resolve(ImageMainViewModel.self, argument: arg1)!)
        }).inObjectScope(.transient)
        
        container.register(ImageDetailView.self, factory: { (
            resolver: Resolver,
            arg1: ImageDetailViewModel.ViewType,
            arg2: ImageType,
            arg3: ImageMainViewModelItem
        ) -> ImageDetailView in
            return .init(vm: resolver.resolve(ImageDetailViewModel.self, arguments: arg1, arg2, arg3)!)
        }).inObjectScope(.transient)
    }
}
