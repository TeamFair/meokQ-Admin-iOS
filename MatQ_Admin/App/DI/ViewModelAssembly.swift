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
                         deleteQuestUseCase: resolver.resolve(DeleteQuestUseCaseInterface.self)!,
                         imageCache: resolver.resolve(ImageCache.self)!)
        }).inObjectScope(.transient)
        
        
        // MARK: - Manage
        container.register(ManageMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> ManageMainViewModel in
            return .init(getChallengeUseCase: resolver.resolve(GetChallengeUseCaseInterface.self)!)
        }).inObjectScope(.transient)
        
        container.register(ManageDetailViewModel.self, factory: { (
            resolver: Resolver,
            arg1: Challenge
        ) -> ManageDetailViewModel in
            return .init(challengeDetail: arg1,
                         patchChallengeUseCase: resolver.resolve(PatchChallengeUseCaseInterface.self)!,
                         deleteChallengeUseCase: resolver.resolve(DeleteChallengeUseCaseInterface.self)!)
        }).inObjectScope(.transient)
        
        
        // MARK: - Banner
        container.register(BannerMainViewModel.self, factory: { (
            resolver: Resolver
        ) -> BannerMainViewModel in
            return .init(bannerUseCase: resolver.resolve(GetBannersUseCaseInterface.self)!)
        }).inObjectScope(.container)
        
        container.register(
            BannerDetailViewModel.self,
            factory: { (
                resolver: Resolver,
                viewType: BannerDetailViewModel.ViewType,
                banner: Banner
            ) -> BannerDetailViewModel in
                return .init(
                    viewType: viewType,
                    banner: banner,
                    postBannerUseCase: resolver.resolve(PostBannerUseCaseInterface.self)!,
                    putBannerUseCase: resolver.resolve(PutBannerUseCaseInterface.self)!,
                    deleteBannerUseCase: resolver.resolve(DeleteBannerUseCaseInterface.self)!,
                    imageCache: resolver.resolve(ImageCache.self)!
                )
        }).inObjectScope(.transient)
        
        
        // MARK: - Image
        container.register(ImageMainViewModel.self, factory: { (
            resolver: Resolver,
            arg1: ImageMainViewModel.ViewType
        ) -> ImageMainViewModel in
            return .init(fetchImagesUseCase: resolver.resolve(FetchImagesUseCaseInterface.self)!, type: arg1)
        }).inObjectScope(.transient)
        
        container.register(
            ImageDetailViewModel.self,
            factory: { (
                resolver: Resolver,
                arg1: ImageDetailViewModel.ViewType,
                arg2: ImageType,
                arg3: ImageMainViewModelItem
            ) -> ImageDetailViewModel in
                return .init(
                    viewType: arg1,
                    imageType: arg2,
                    imageItem: arg3,
                    imageRepository: resolver.resolve(ImageRepositoryInterface.self)!
                )
            }).inObjectScope(.transient)
    }
}
