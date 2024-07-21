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
