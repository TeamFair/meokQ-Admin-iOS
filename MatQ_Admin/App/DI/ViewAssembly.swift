//
//  ViewAssembly.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

final class ViewAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: - Market View

        container.register(MarketMainView.self, factory: { (
            resolver: Resolver
        ) -> MarketMainView in
            return .init(vm: resolver.resolve(MarketMainViewModel.self)!)
        })
        
        container.register(MarketAuthReviewView.self, factory: { (
            resolver: Resolver,
            arg: String
        ) -> MarketAuthReviewView in
            return .init(vm: resolver.resolve(MarketAuthReviewViewModel.self, argument: arg)!)
        })
        
        container.register(BusinessRegistrationView.self, factory: { (
            resolver: Resolver,
            arg: License
        ) -> BusinessRegistrationView in
            return .init(license: arg)
        })
        
        container.register(MarketDetailInfoView.self, factory: { (
            resolver: Resolver,
            arg: MarketDetail
        ) -> MarketDetailInfoView in
            return .init(marketDetail: arg)
        })
        
        container.register(IdentificationView.self, factory: { (
            resolver: Resolver,
            arg: Operator
        ) -> IdentificationView in
            return .init(operatorData: arg)
        })
        
     
        // MARK: - Notice View
        
        container.register(NoticeMainView.self, factory: { (
            resolver: Resolver
        ) -> NoticeMainView in
            return .init()
        })
        
        container.register(NoticePostView.self, factory: { (
            resolver: Resolver
        ) -> NoticePostView in
            return .init()
        })
        
        container.register(NoticeDetailView.self, factory: { (
            resolver: Resolver
        ) -> NoticeDetailView in
            return .init()
        })
    }
}
