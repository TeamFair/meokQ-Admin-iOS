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
                    changePortButton
                }
            
            switch vm.viewState {
            case .empty:
                VStack {
                    Text("불러올 퀘스트가 없어요!")
                        .font(.callout)
                        .foregroundStyle(.textSecondary)
                    Button {
                        vm.getQuestList(page: 0)
                    } label: {
                        Text("재시도")
                    }
                }
                .frame(maxHeight: .infinity)
                
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                questListView
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                router.push(.QuestDetailView(type: .publish, quest: Quest.init()))
            } label: {
                Text("퀘스트 생성")
            }
            .ilsangButtonStyle(type: .primary)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(.bgSecondary)
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
    
    private var questListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                if vm.showSearchBar {
                    SearchTextField(
                        searchText: $vm.searchText,
                        clearAction: { vm.clearSearchText() }
                    )
                    .transition(.move(edge: .top).combined(with: .scale).combined(with: .opacity))
                    .animation(.easeInOut, value: vm.showSearchBar)
                }
                
                HStack(spacing: 10) {
                    selectTypeView
                    selectMissionTypeView
                    Spacer(minLength: 0)
                    showPopular(vm.showPopularOnly)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, vm.showSearchBar ? 12 : 2)
            .padding(.bottom, 12)
            .background(
                Rectangle()
                    .fill(.bg)
                    .shadow(color: Color.textPrimary.opacity(0.03), radius: 14, y: 8)
            )
            
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .frame(height: 20) // 스크롤 위치 감지용
                        .onChange(of: geometry.frame(in: .named("QuestScrollView")).minY) { _, value in
                            vm.updateSearchBarVisibility(offset: value)
                        }
                }
                
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(vm.filteredItems, id: \.questId) { item in
                        Button {
                            if let selectedQuest = vm.getSelectedQuest(item) {
                                router.push(.QuestDetailView(type: .edit, quest: selectedQuest))
                            }
                        } label: {
                            QuestItemView(
                                questImage: item.writerImage,
                                mainQuestImage: item.mainImage,
                                mission: item.mission,
                                writer: item.writer,
                                target: item.target,
                                stats: item.xpStats
                            )
                            .opacity(item.status == "DELETED" ? 0.3 : 1)
                        }
                    }
                }
                Spacer().frame(height: 60)
            }
            .refreshable {
                vm.getQuestList(page: 0)
            }
        }
    }
    
    private var selectTypeView: some View {
        HStack(spacing: 8) {
            ForEach(QuestType.allCases, id: \.id) { type in
                let isSelectedType = vm.selectedType[type] ?? false
                Button {
                    vm.selectedType[type]?.toggle()
                } label: {
                    Text(type.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isSelectedType ? .primaryPurple : .textSecondary)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelectedType ? Color.primaryPurple.opacity(0.15) : Color.gray.opacity(0.1))
                                .stroke(isSelectedType ? .primaryPurple.opacity(0.7) : .gray, style: .init(lineWidth: 0.5))
                        )
                }
            }
        }
    }
    
    private var selectMissionTypeView: some View {
        HStack(spacing: 8) {
            ForEach(MissionType.allCases, id: \.id) { type in
                let isSelectedType = vm.selectedMissionType[type] ?? false
                Button {
                    vm.selectedMissionType[type]?.toggle()
                } label: {
                    switch type {
                    case .FREE:
                        tagView("📸", isSelcted: isSelectedType)
                    case .OX:
                        tagView("🙆🏻", isSelcted: isSelectedType)
                    default:
                        tagView("✏️", isSelcted: isSelectedType)
                    }
                }
            }
        }
    }
    
    private func tagView(_ title: String, isSelcted: Bool) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .foregroundStyle(isSelcted ? .primaryPurple : .textSecondary)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelcted ? Color.primaryPurple.opacity(0.15) : Color.gray.opacity(0.1))
                    .stroke(isSelcted ? .primaryPurple.opacity(0.7) : .gray, style: .init(lineWidth: 0.5))
            )
    }
    
    private func showPopular(_ show: Bool) -> some View {
        Button {
            vm.showPopularOnly.toggle()
        } label: {
            Image(systemName: show ? "star.fill" : "star")
                .resizable()
                .scaledToFit()
                .fontWeight(.light)
                .foregroundStyle(show ? .primaryPurple : .gray300)
                .frame(width: 18)
                .padding(.vertical, 6)
                .padding(.horizontal, 4)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    QuestMainView(
        vm: QuestMainViewModel(
            questUseCase: GetQuestUseCase(
                questRepository: MockQuestRepository(),
                imageRepository: MockImageRepository()
            )
        )
    )
}
