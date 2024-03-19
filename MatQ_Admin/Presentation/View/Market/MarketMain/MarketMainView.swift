//
//  MainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/3/24.
//

import SwiftUI

struct MarketMainView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: MarketMainViewModel
 
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "마켓 심사", isNotRoot: false)
                  
            switch vm.viewState {
            case .empty:
                Text("심사할 마켓이 없어요!")
                    .font(.callout)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity)
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                marketListView
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
    
    private var marketListView: some View {
        ScrollView {
            Spacer().frame(height: 20)
            ForEach(Array(vm.items), id: \.marketId) { item in
                Button {
                    router.push(.MarketAuthReviewView(marketId: item.marketId))
                } label: {
                    MarketComponent(marketImage: item.logoImage ?? .testimage, marketName: item.name)
                }
            }
            Spacer(minLength: 60)
        }
        .refreshable {
            await vm.getMarketList(page: 0)
        }
    }
}
