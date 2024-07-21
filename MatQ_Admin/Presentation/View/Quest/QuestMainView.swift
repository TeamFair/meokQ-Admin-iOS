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
            .padding(20)
        }
        .background(.bgSecondary)
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
                                        rewardTitle: $0.rewardTitle,
                                        status: $0.status,
                                        publisher: $0.publisher,
                                        logoImageId: $0.logoImageId,
                                        expireDate: $0.expireDate
                                    )
                                })!
                        )
                    )
                } label: {
                    QuestItemView(questImage: item.logoImage ?? .testimage, missionTitle: item.questTitle, expireDate: item.expireDate)
                }
            }
            Spacer(minLength: 60)
        }
    }
}

#Preview {
    QuestMainView(vm: QuestMainViewModel())
}