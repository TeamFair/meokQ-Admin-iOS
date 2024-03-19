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
    
    var appInject = AppInject()
    
    var body: some Scene {
        WindowGroup {
            MainView(coordinator: appInject.coordinator)
        }
    }
}
