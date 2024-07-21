//
//  AppInject.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI
import Swinject

class AppInject {
    private let injector: DependencyInjector
    @ObservedObject var coordinator: NavigationStackCoordinator = NavigationStackCoordinator(.QuestMainView)
    
    init() {
        injector = DependencyInjector(container: Container())
        // coordinator = NavigationStackCoordinator(.MarketMainView)
        coordinator.injector = injector
        
        injector.assemble([
            DataAssembly(),
            DomainAssembly(),
            ViewModelAssembly(),
            ViewAssembly()
        ])
    }
}
