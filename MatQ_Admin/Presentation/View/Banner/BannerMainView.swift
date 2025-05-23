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
                .zIndex(5)
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
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
        }
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
            vm.showingAlert = true
        } label: {
            Image(systemName: "terminal")
        }
        .padding(.trailing, 20)
        .alert("포트번호 변경", isPresented: $vm.showingAlert, actions: {
            TextField("\(vm.port)", text: $vm.portText)
            
            Button("변경", action: {
                vm.port = vm.portText
                vm.getBanners()
                vm.showingAlert = false
            })
            .disabled(vm.portText == "")
            
            Button("취소", role: .cancel, action: {})
        }, message: {
            Text("변경할 포트번호을 작성해주세요.")
        })
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
