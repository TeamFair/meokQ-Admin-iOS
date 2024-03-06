//
//  MatQ_AdminApp.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI
import Swinject

@main
struct MatQ_AdminApp: App {
    
    @ObservedObject var coordinator: NavigationStackCoordinator
    private let injector: Injector
    
    init() {
        injector = DependencyInjector(container: Container())
        coordinator = NavigationStackCoordinator(.MarketMainView)
        coordinator.injector = injector
        
        injector.assemble([
            DataAssembly(),
            DomainAssembly(),
            ViewModelAssembly(),
            ViewAssembly()
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(coordinator: coordinator)
        }
    }
}
