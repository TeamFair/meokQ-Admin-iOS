//
//  MainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import SwiftUI

struct MarketMainView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    @ObservedObject var vm: MarketMainViewModel
 
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "마켓 심사", isNotRoot: false)
                        
            ScrollView {
                Spacer().frame(height: 20)
                ForEach(Array(vm.items), id: \.marketId) { item in
                    Button {
                        router.push(.MarketAuthReviewView(marketId: item.marketId))
                    } label: {
                        MarketComponent(marketImage: item.logoImageId, marketName: item.name)
                    }
                }
                Spacer(minLength: 60)
            }
        }
        .task {
            await vm.getMarketList(page: 0)
        }
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
        }
        .background(Color.gray.opacity(0.05))
    }
}
