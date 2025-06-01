//
//  ManageMainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import SwiftUI

struct ManageMainView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: ManageMainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "관리", isNotRoot: false)
                .overlay(alignment: .trailing) {
                    changePortButton
                }
            
            switch vm.viewState {
            case .empty:
                Text("신고된 목록이 없어요!")
                    .font(.callout)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity)
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                reportListView
            }
        }
        .background(.bgSecondary)
        .task {
            vm.getReportedList(page: 0)
        }
        .alertItem(vm.alertItem, isPresented: $vm.showAlert)
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
    
    private var reportListView: some View {
        ScrollView {
            Spacer().frame(height: 20)
            ForEach(vm.items, id: \.challengeId) { item in
                Button {
                    router.push(
                        .ManageDetailView(challenge: vm.challengeList
                            .first(where: { $0.challengeId == item.challengeId })!
                        )
                    )
                    
                } label: {
                    // TODO: 라벨 변경
                    ManageListItemView(challengeTitle: item.questTitle, userNickname: item.createdAt)
                }
            }
            Spacer(minLength: 60)
        }
        .refreshable {
            vm.getReportedList(page: 0)
        }
    }
}

//#Preview {
//    QuestMainView(vm: QuestMainViewModel())
//}
