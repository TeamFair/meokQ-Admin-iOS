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
                        vm.showingAlert = true
                    } label: {
                        Image(systemName: "terminal")
                    }
                    .padding(.trailing, 20)
                }
                .alert("포트번호 변경", isPresented: $vm.showingAlert, actions: {
                    TextField("\(vm.port)", text: $vm.portText)
                    
                    Button("변경", action: {
                        vm.port = vm.portText
                    })
                    .disabled(vm.portText == "")
                    
                    Button("취소", role: .cancel, action: {})
                }, message: {
                    Text("변경할 포트번호을 작성해주세요.")
                })
            
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
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var reportListView: some View {
        ScrollView {
            Spacer().frame(height: 20)
            ForEach(vm.items, id: \.questId) { item in
                Button {
                    router.push(
                        .ManageDetailView(quest: vm.questList
                            .first(where: { $0.questId == item.questId })
                            .map {
                                Quest(
                                    questId: $0.questId,
                                    missionTitle: $0.missionTitle,
                                    quantity: $0.quantity,
                                    status: $0.status,
                                    writer: $0.writer,
                                    image: $0.image,
                                    logoImageId: $0.logoImageId ?? "",
                                    expireDate: $0.expireDate
                                )
                            }!
                        )
                    )
                    
                } label: {
                    ManageListItemView(challengeTitle: item.questTitle, userNickname: item.expireDate)
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
