//
//  QuestMainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct QuestMainView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: QuestMainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "퀘스트", isNotRoot: false)
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
                        vm.showingAlert = false
                    })
                    .disabled(vm.portText == "")
                    
                    Button("취소", role: .cancel, action: {})
                }, message: {
                    Text("변경할 포트번호을 작성해주세요.")
                })
            
            switch vm.viewState {
            case .empty:
                Text("불러올 퀘스트가 없어요!")
                    .font(.callout)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity)
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                marketListView
            }
            
            Button {
                router.push(.QuestDetailView(type: .publish, quest: Quest.init()))
            } label: {
                Text("퀘스트 생성")
            }
            .ilsangButtonStyle(type: .primary)
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(.bgSecondary)
        .task {
            vm.getQuestList(page: 0)
        }
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var marketListView: some View {
        ScrollView {
            Spacer().frame(height: 20)
            ForEach(vm.items, id: \.questId) { item in
                Button {
                    router.push(
                        .QuestDetailView(
                            type: .edit,
                            quest: vm.questList
                                .first(where: { $0.questId == item.questId })
                                .map({
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
                                })!
                        )
                    )
                } label: {
                    QuestItemView(questImage: item.logoImage ?? .nullimage, missionTitle: item.questTitle, expireDate: item.expireDate)
                        .opacity(item.status == "DELETED" ? 0.3 : 1)
                }
            }
            Spacer(minLength: 60)
        }
        .refreshable {
            await vm.getQuestList(page: 0)
        }
    }
}

//#Preview {
//    QuestMainView(vm: QuestMainViewModel())
//}
