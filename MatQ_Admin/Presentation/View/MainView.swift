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
        case notice
    }
    @ObservedObject var coordinator: NavigationStackCoordinator
    @State private var selectedTab: Tab = .quest
    
    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            TabView(selection: $selectedTab) {
                coordinator.buildInitialScene()
                    .tabItem {
                        Label("퀘스트", systemImage: "checkerboard.rectangle")
                    }
                    .tag(Tab.quest)
                
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
    MainView(coordinator: .init(.QuestMainView))
}
