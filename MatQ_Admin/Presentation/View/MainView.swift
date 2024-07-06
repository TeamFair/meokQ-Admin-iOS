//
//  ContentView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI
import Swinject

struct MainView: View {
    enum Tab {
        case quest
        case market
        case notice
    }
    @ObservedObject var coordinator: NavigationStackCoordinator
    @State private var selectedTab: Tab = .market
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            TabView(selection: $selectedTab) {
                coordinator.buildInitialScene(path: .QuestMainView)
                    .tabItem {
                        Label("퀘스트", systemImage: "checkerboard.rectangle")
                    }
                    .tag(Tab.market)
                coordinator.buildInitialScene()
                    .tabItem {
                        Label("마켓", systemImage: "house")
                    }
                    .tag(Tab.market)
                
                coordinator.buildInitialScene(path: .NoticeMainView)
                    .tabItem {
                        Label("공지사항", systemImage: "note.text")
                    }
                    .tag(Tab.notice)
            }
            .tint(.tintYellow)
            .environmentObject(coordinator)
            .navigationDestination(for: Path.self) { path in
                coordinator.buildScene(path: path)
                    .navigationBarBackButtonHidden()
                    .environmentObject(coordinator)
            }
        }
    }
}

#Preview {
    MainView(coordinator: .init(.MarketMainView))
}
