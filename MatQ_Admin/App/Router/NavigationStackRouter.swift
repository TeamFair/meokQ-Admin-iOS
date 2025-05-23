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
        case .BannerMainView:
            injector?.resolve(BannerMainView.self)
        case .BannerDetailView(let type, let quest):
            injector?.resolve(BannerDetailView.self, argument1: type, argument2: quest)
        case .ManageMainView:
            injector?.resolve(ManageMainView.self)
        case .ManageDetailView(let challenge):
            injector?.resolve(ManageDetailView.self, argument: challenge)
        case .ImageMainView(let type):
            injector?.resolve(ImageMainView.self, argument: type)
        case .ImageDetailView(let type, let imageItem):
            injector?.resolve(ImageDetailView.self, argument1: type, argument2: imageItem)
        }
    }
    
}

enum Path: Hashable {
    //Quest
    case QuestMainView
    case QuestDetailView(type: QuestDetailViewModel.ViewType, quest: Quest)
    
    //Banner
    case BannerMainView
    case BannerDetailView(type: BannerDetailViewModel.ViewType, banner: Banner)
    
    // Manage
    case ManageMainView
    case ManageDetailView(challenge: Challenge)
    
    //Image
    case ImageMainView(type: ImageMainViewModel.ViewType)
    case ImageDetailView(type: ImageDetailViewModel.ViewType, imageItem: ImageMainViewModelItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .QuestMainView:
            hasher.combine("QuestMainView")
        case .QuestDetailView:
            hasher.combine("QuestDetailView")
        case .BannerMainView:
            hasher.combine("BannerMainView")
        case .BannerDetailView:
            hasher.combine("BannerDetailView")
        case .ManageMainView:
            hasher.combine("ManageMainView")
        case .ManageDetailView:
            hasher.combine("ManageDetailView")
        case .ImageMainView:
            hasher.combine("ImageMainView")
        case .ImageDetailView:
            hasher.combine("ImageDetailView")
        }
    }
    
    static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.QuestMainView, .QuestMainView):
            return true
        case (.QuestDetailView, .QuestDetailView):
            return true
        case (.BannerMainView, .BannerMainView):
            return true
        case (.BannerDetailView, .BannerDetailView):
            return true
        case (.ManageMainView, .ManageMainView):
            return true
        case (.ManageDetailView, .ManageDetailView):
            return true
        case (.ImageMainView, .ImageMainView):
            return true
        case (.ImageDetailView, .ImageDetailView):
            return true
        default:
            return false
        }
    }
}
