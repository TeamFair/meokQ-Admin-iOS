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
        case manage
        case image
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
                
                coordinator.buildInitialScene(path: .ManageMainView)
                    .tabItem {
                        Label("관리", systemImage: "tray.full.fill")
                    }
                    .tag(Tab.manage)
                coordinator.buildInitialScene(path: .ImageMainView)
                    .tabItem {
                        Label("이미지", systemImage: "photo.on.rectangle.angled")
                    }
                    .tag(Tab.image)
            }
            .tint(.primaryPurple)
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
