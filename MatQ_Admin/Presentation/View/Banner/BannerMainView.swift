//
//  BannerMainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import SwiftUI

/// 배너는 10개만 조회됩니다.
struct BannerMainView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: BannerMainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "배너", isNotRoot: false)
                .overlay(alignment: .trailing) {
                    changePortButton
                }
            
            switch vm.viewState {
            case .empty:
                emptyListView
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                bannerListView
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                router.push(.BannerDetailView(type: .publish, banner: Banner.init()))
            } label: {
                Text("배너 생성")
            }
            .ilsangButtonStyle(type: .primary)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(.bgSecondary)
        .alertItem(vm.alertItem, isPresented: $vm.showAlert)
    }
    
    private var bannerListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(vm.banners, id: \.id) { banner in
                        Button {
                             if let selectedBanner = vm.getSelectedBanner(banner) {
                                 router.push(.BannerDetailView(type: .edit, banner: selectedBanner))
                             }
                        } label: {
                            BannerItemView(banner: banner)
                                .opacity(banner.activeYn ? 1 : 0.4)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
            .scrollDisabled(vm.banners.isEmpty)
            .refreshable {
                vm.getBanners()
            }
        }
    }
    
    private var emptyListView: some View {
        VStack {
            Text("불러올 배너가 없어요!")
                .font(.callout)
                .foregroundStyle(.textSecondary)
            Button {
                vm.getBanners()
            } label: {
                Text("재시도")
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var changePortButton: some View {
        Button {
            vm.showPortChangeSheet()
        } label: {
            Image(systemName: "terminal")
        }
        .padding(.trailing, 20)
        .sheet(isPresented: $vm.showPortSheet) {
            ServerSelectionSheetView(isPresented: $vm.showPortSheet) { _ in
                vm.onPortChanged()
            }
            .presentationDetents([.height(220)])
        }
    }
}


#Preview {
    BannerMainView(
        vm: BannerMainViewModel(
            bannerUseCase: GetBannersUseCase(
                bannerRepository: MockBannerRepository(),
                imageRepository: MockImageRepository()
            )
        )
    )
}
