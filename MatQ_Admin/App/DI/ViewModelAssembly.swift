//
//  ViewModelAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: - Quest
        
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
                         putQuestUseCase: resolver.resolve(PutQuestUseCaseInterface.self)!,
                         deleteQuestUseCase: resolver.resolve(DeleteQuestUseCaseInterface.self)!)
        }).inObjectScope(.transient)
        
        
        // MARK: - Manage
        container.register(ManageMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> ManageMainViewModel in
            return .init(getChallengeUseCase: resolver.resolve(GetChallengeUseCaseInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(ManageDetailViewModel.self, factory: { (
            resolver: Resolver,
            arg1: Challenge
        ) -> ManageDetailViewModel in
            return .init(challengeDetail: arg1,
                         patchChallengeUseCase: resolver.resolve(PatchChallengeUseCaseInterface.self)!,
                         deleteChallengeUseCase: resolver.resolve(DeleteChallengeUseCaseInterface.self)!)
        }).inObjectScope(.transient)
        
        // MARK: - Image
        container.register(ImageMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> ImageMainViewModel in
            return .init(fetchImagesUseCase: resolver.resolve(FetchCachedImagesUseCaseInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(
            ImageDetailViewModel.self,
            factory: { (
                resolver: Resolver,
                arg1: ImageDetailViewModel.ViewType,
                arg2: ImageMainViewModelItem
            ) -> ImageDetailViewModel in
                return .init(
                    viewType: arg1,
                    imageItem: arg2,
                    imageRepository: resolver.resolve(ImageRepositoryInterface.self)!
                )
            }).inObjectScope(.transient)
    }
}
