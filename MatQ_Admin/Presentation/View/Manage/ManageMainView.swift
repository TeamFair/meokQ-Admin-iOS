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
                    Button {
                        vm.activeAlertType = .portchange
                        vm.showAlert = true
                    } label: {
                        Image(systemName: "terminal")
                    }
                    .padding(.trailing, 20)
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
        .alert(
            Text(vm.activeAlertType == .portchange ? "포트번호 변경" : "네트워크 에러"),
            isPresented: $vm.showAlert,
            actions: {
                switch vm.activeAlertType {
                case .portchange:
                    TextField("\(vm.port)", text: $vm.portText)
                    
                    Button("변경", action: {
                        vm.port = vm.portText
                        vm.getReportedList(page: 0)
                        vm.showAlert = false
                    })
                    .disabled(vm.portText == "")
                    
                    Button("취소", role: .cancel, action: {})
                case .networkError:
                    Button(role: .cancel, action: { }, label: {Text("확인")})
                case .none:
                    Button(role: .cancel, action: { }, label: {Text("확인")})
                }
            },
            message: {
                Text(vm.activeAlertType == .portchange ? "변경할 포트번호을 작성해주세요." : vm.errorMessage)
            })
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
