//
//  NavigationStackCoordinator.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

public class NavigationStackCoordinator: ObservableObject {
    
    @Published public var paths: NavigationPath
    private let initialScene: Path
    
    var injector: Injector?
    
    init(_ initialScene: Path) {
        self.initialScene = initialScene
        self.paths = NavigationPath()
    }
    
    public func buildInitialScene() -> some View {
        return buildScene(path: initialScene)
    }
    
    func buildInitialScene(path: Path) -> some View {
        return buildScene(path: path)
    }
    
    func push(_ path: Path) {
        paths.append(path)
    }

    func pop() {
        if !paths.isEmpty {
            paths.removeLast(1)
        }
    }

    func popToRoot() {
        paths.removeLast(paths.count)
    }
    
    @ViewBuilder
    func buildScene(path: Path) -> some View {
        
        switch path {
        case .QuestMainView:
            injector?.resolve(QuestMainView.self)
        case .QuestDetailView(let type, let quest):
            injector?.resolve(QuestDetailView.self, argument1: type, argument2: quest)
        case .MarketMainView:
            injector?.resolve(MarketMainView.self)
        case .MarketAuthReviewView(let marketId):
            injector?.resolve(MarketAuthReviewView.self, argument: marketId)
        case .BusinessRegistrationView(let license):
            injector?.resolve(BusinessRegistrationView.self, argument: license)
        case .IdentificationView(let `operator`):
            injector?.resolve(IdentificationView.self, argument: `operator`)
        case .MarketDetailInfoView(let detail):
            injector?.resolve(MarketDetailInfoView.self, argument: detail)
        case .PopupReject(let review):
            injector?.resolve(PopupView.self, argument: review)
        case .PopupConfirm(let review):
            injector?.resolve(PopupView.self, argument: review)
        case .NoticeMainView:
            injector?.resolve(NoticeMainView.self)
        case .NoticePostView:
            injector?.resolve(NoticePostView.self)
        case .NoticeDetailView(let notice):
            injector?.resolve(NoticeDetailView.self, argument: notice)
        }
    }
    
}

enum Path: Hashable {
    //Quest
    case QuestMainView
    case QuestDetailView(type: QuestDetailViewModel.ViewType, quest: Quest)
    
    //Market
    case MarketMainView
    case MarketAuthReviewView(marketId: String)
    case BusinessRegistrationView(license: License)
    case IdentificationView(operator: Operator)
    case MarketDetailInfoView(detail: MarketDetail)
    case PopupReject(review: PutReviewMarketAuthRequest)
    case PopupConfirm(review: PutReviewMarketAuthRequest)
   
    //Notice
    case NoticeMainView
    case NoticePostView
    case NoticeDetailView(notice: Notice)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .QuestMainView:
            hasher.combine("QuestMainView")
        case .QuestDetailView:
            hasher.combine("QuestDetailView")
        case .MarketMainView:
            hasher.combine("MarketMainView")
        case .MarketAuthReviewView(_):
            hasher.combine("MarketDetailView")
        case .BusinessRegistrationView:
            hasher.combine("BusinessRegistrationView")
        case .IdentificationView:
            hasher.combine("IdentificationView")
        case .MarketDetailInfoView:
            hasher.combine("MarketInfoView")
        case .PopupReject(let review):
            hasher.combine("PopupReject")
            review.recordId.hash(into: &hasher)
        case .PopupConfirm(let review):
            hasher.combine("PopupConfirm")
            review.recordId.hash(into: &hasher)
        case .NoticeMainView:
            hasher.combine("NoticeMainView")
        case .NoticePostView:
            hasher.combine("NoticePostView")
        case .NoticeDetailView:
            hasher.combine("NoticeDetailView")
        }
    }
    
    static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.QuestMainView, .QuestDetailView):
            return true
        case (.MarketMainView, .MarketMainView):
            return true
        case (.MarketAuthReviewView, .MarketAuthReviewView):
            return true
        case (.BusinessRegistrationView, .BusinessRegistrationView):
            return true
        case (.IdentificationView, .IdentificationView):
            return true
        case (.MarketDetailInfoView, .MarketDetailInfoView):
            return true
        case (.PopupReject(let review1), .PopupReject(let review2)):
            return review1.recordId == review2.recordId
        case (.PopupConfirm(let review1), .PopupConfirm(let review2)):
            return review1.recordId == review2.recordId
        case (.NoticeMainView, .NoticeMainView):
            return true
        case (.NoticePostView, .NoticePostView):
            return true
        case (.NoticeDetailView, .NoticeDetailView):
            return true
        default:
            return false
        }
    }
}
